async function test() {
  console.log("Testing registration to get token...");
  const email = "test.auth." + Date.now() + "@example.com";
  const regRes = await fetch("http://localhost:3000/api/auth/register", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      fullName: "Test Auth",
      collegeName: "Test College",
      email: email,
      phoneNumber: "9" + Math.floor(100000000 + Math.random() * 900000000).toString(),
      password: "Password123!",
      confirmPassword: "Password123!",
    })
  });
  console.log("Registration status:", regRes.status);
  
  const cookies = regRes.headers.get("set-cookie");
  console.log("Set-Cookie:", cookies);
  
  if (!cookies) {
     console.log("No cookie returned!");
     return;
  }
  
  const occTokenMatch = cookies.match(/occ-token=([^;]+)/);
  const token = occTokenMatch ? occTokenMatch[1] : null;
  console.log("Token:", token ? "Found" : "Not Found");
  
  console.log("\nTesting /api/profile with token...");
  const profRes = await fetch("http://localhost:3000/api/profile", {
    method: "GET",
    headers: {
      "Cookie": `occ-token=${token}`
    }
  });
  console.log("Profile status:", profRes.status);
  const data = await profRes.json();
  console.log("Profile response:", data);
}

test();
