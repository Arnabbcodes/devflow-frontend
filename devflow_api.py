from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import time

app = FastAPI(title="DevFlow AI Orchestrator")

# Critical for Flutter Web: This allows your frontend to talk to your backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins for hackathon ease
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class FixRequest(BaseModel):
    issue_id: str

@app.post("/api/analyze")
def analyze_project():
    # In a full app, you would send the uploaded Python file to Groq here.
    # For the 48-hour hackathon, we return the exact flaws you built into your vulnerable app!
    
    return {
        "health_score": 61,
        "metrics": {
            "bugs": 1,
            "security": 2,
            "tests": 6
        },
        "issues": [
            {
                "id": "jwt-vuln-001",
                "type": "security",
                "title": "JWT authentication vulnerability",
                "file": "main.py",
                "line": 19,
                "description": "Missing signature verification (verify_signature: False) allows arbitrary token forgery."
            },
            {
                "id": "hardcoded-auth-002",
                "type": "security",
                "title": "Hardcoded Credentials in Plaintext",
                "file": "main.py",
                "line": 13,
                "description": "Admin credentials are hardcoded and compared in plaintext."
            },
            {
                "id": "silent-catch-003",
                "type": "bug",
                "title": "Silent Catch-All Exception",
                "file": "main.py",
                "line": 28,
                "description": "Silent catch-all exception swallows errors like TypeError without logging."
            }
        ]
    }

@app.post("/api/fix")
def generate_fix(request: FixRequest):
    time.sleep(1) # Simulate AI thinking time
    
    fixes = {
        "jwt-vuln-001": {
            "status": "success",
            "fix_plan": [
                "Identify vulnerable jwt.decode implementation (Security Agent)",
                "Enforce strict signature validation with SECRET key (Backend Agent)",
                "Generate token forgery regression test (Test Agent)",
                "Verify correction"
            ],
            "before_tests": {"total": 12, "passed": 7, "failed": 5},
            "after_tests": {"total": 18, "passed": 18, "failed": 0},
            "fixed_code": 'payload = jwt.decode(token, SECRET, algorithms=["HS256"])'
        },
        "hardcoded-auth-002": {
            "status": "success",
            "fix_plan": [
                "Scan plaintext credentials and hash usage (Security Agent)",
                "Migrate credentials to bcrypt password hashing (Backend Agent)",
                "Generate credential brute-force test (Test Agent)",
                "Verify secure authentication"
            ],
            "before_tests": {"total": 10, "passed": 5, "failed": 5},
            "after_tests": {"total": 15, "passed": 15, "failed": 0},
            "fixed_code": 'pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")\ndef verify_password(plain, hashed):\n    return pwd_context.verify(plain, hashed)'
        },
        "silent-catch-003": {
            "status": "success",
            "fix_plan": [
                "Detect bare try-except blocks swallowing errors (Bug Agent)",
                "Replace with specific ValueError/TypeError logging (Backend Agent)",
                "Generate exception handling unit test (Test Agent)",
                "Verify edge-case inputs"
            ],
            "before_tests": {"total": 8, "passed": 4, "failed": 4},
            "after_tests": {"total": 12, "passed": 12, "failed": 0},
            "fixed_code": 'try:\n    result = int(data.get("value", 0)) * 100\n    return {"result": result}\nexcept (ValueError, TypeError) as e:\n    logger.error(f"Invalid data input: {e}")\n    raise HTTPException(status_code=400, detail="Invalid numeric value")'
        }
    }
    
    return fixes.get(request.issue_id, {
        "status": "success",
        "fix_plan": [
            "Analyze issue AST (Backend Agent)",
            "Generate patch (Backend Agent)",
            "Generate regression tests (Test Agent)",
            "Verify fix"
        ],
        "before_tests": {"total": 5, "passed": 2, "failed": 3},
        "after_tests": {"total": 8, "passed": 8, "failed": 0},
        "fixed_code": "# Automatically patched by DevFlow Agents\nreturn True"
    })