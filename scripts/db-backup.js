import { S3Client, PutObjectCommand } from "@aws-sdk/client-s3";
import { execSync } from "child_process";
import fs from "fs";
import path from "path";
import dotenv from "dotenv";

dotenv.config();

// Configuration
const DATABASE_URL = process.env.DATABASE_URL;
const R2_ACCOUNT_ID = process.env.R2_ACCOUNT_ID;
const R2_ACCESS_KEY_ID = process.env.R2_ACCESS_KEY_ID;
const R2_SECRET_ACCESS_KEY = process.env.R2_SECRET_ACCESS_KEY;
const R2_BUCKET_NAME = process.env.R2_BUCKET_NAME;

if (!DATABASE_URL || !R2_ACCOUNT_ID || !R2_ACCESS_KEY_ID || !R2_SECRET_ACCESS_KEY || !R2_BUCKET_NAME) {
  console.error("Missing environment variables for backup.");
  process.exit(1);
}

const s3Client = new S3Client({
  region: "auto",
  endpoint: `https://${R2_ACCOUNT_ID}.r2.cloudflarestorage.com`,
  credentials: {
    accessKeyId: R2_ACCESS_KEY_ID,
    secretAccessKey: R2_SECRET_ACCESS_KEY,
  },
});

async function runBackup() {
  const timestamp = new Date().toISOString().replace(/[:.]/g, "-");
  const filename = `db-backup-${timestamp}.sql`;
  const filepath = path.join(process.cwd(), filename);

  console.log(`Starting backup: ${filename}...`);

  try {
    // 1. Export database via pg_dump
    // Note: This requires postgresql-client installed on the machine/container
    execSync(`pg_dump "${DATABASE_URL}" > "${filepath}"`);
    console.log("Database exported successfully.");

    // 2. Upload to R2
    const fileContent = fs.readFileSync(filepath);
    const uploadParams = {
      Bucket: R2_BUCKET_NAME,
      Key: `backups/${filename}`,
      Body: fileContent,
      ContentType: "application/sql",
    };

    await s3Client.send(new PutObjectCommand(uploadParams));
    console.log(`Successfully uploaded ${filename} to R2 bucket: ${R2_BUCKET_NAME}`);

    // 3. Cleanup local file
    fs.unlinkSync(filepath);
    console.log("Local backup file removed.");
    
  } catch (error) {
    console.error("Backup failed:", error);
    if (fs.existsSync(filepath)) fs.unlinkSync(filepath);
    process.exit(1);
  }
}

runBackup();
