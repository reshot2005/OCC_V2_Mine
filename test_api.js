async function test() {
  console.log("Testing validation...");
  const valRes = await fetch("http://localhost:3000/api/referral/validate", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ code: "ELVINOCC" })
  });
  console.log("Validation status:", valRes.status);
  console.log("Validation response:", await valRes.json());

  console.log("\nTesting registration with dummy data...");
  const regRes = await fetch("http://localhost:3000/api/auth/register", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      fullName: "Test User Validation",
      collegeName: "Test College",
      email: "test.validation." + Date.now() + "@example.com",
      phoneNumber: "9" + Math.floor(100000000 + Math.random() * 900000000).toString(),
      password: "Password123!",
      confirmPassword: "Password123!",
      referralCode: "ELVINOCC"
    })
  });
  console.log("Registration status:", regRes.status);
  console.log("Registration response:", await regRes.json());
}

test();
