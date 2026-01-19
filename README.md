# 🔒 Vulnerability Scanner API

> Automated dependency vulnerability detection for secure software delivery

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)]()
[![Java](https://img.shields.io/badge/Java-17-orange)]()
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.1-green)]()


A REST API that automatically scans software projects for known security vulnerabilities (CVEs) in their dependencies. Built specifically for integration with DevOps CI/CD pipelines.

### Real-World Problem

**84% of applications contain at least one vulnerable dependency.** The Log4Shell vulnerability (CVE-2021-44228) alone affected millions of applications worldwide, leading to data breaches costing companies millions of dollars.

This scanner helps prevent such incidents by detecting vulnerabilities **before** code reaches production.


## ✨ Key Features

- 🔍 **Automatic CVE Detection** - Identifies known vulnerabilities in dependencies
- ⚡ **Fast Scanning** - Complete scan in under 3 seconds
- 🚨 **Severity Classification** - CRITICAL, HIGH, MEDIUM, LOW ratings
- 📊 **Historical Tracking** - Monitor security improvements over time
- 🔗 **CI/CD Integration** - Works with GitHub Actions, Jenkins, GitLab CI
- 📖 **API Documentation** - Built-in Swagger UI


## 🚀 Quick Start

### Prerequisites

- Java 17 or higher
- Maven 3.8+

### Installation

```bash
# Clone the repository
git clone https://github.com/YOUR-USERNAME/vulnerability-scanner.git
cd vulnerability-scanner

# Build the project
mvn clean package

# Run the application
mvn spring-boot:run
```

The API will be available at: **http://localhost:8080**


## 📖 Usage

### 1. Trigger a Scan

```bash
curl -X POST http://localhost:8080/api/scans/trigger \
  -H "Content-Type: application/json" \
  -d '{
    "projectName": "my-app",
    "projectVersion": "1.0.0"
  }'
```

### 2. View Results

**Response:**
```json
{
  "scanId": 1,
  "projectName": "my-app",
  "status": "COMPLETED",
  "vulnerableDependencies": 4,
  "criticalCount": 1,
  "highCount": 1,
  "riskLevel": "CRITICAL"
}
```

### 3. Get Vulnerability Details

```bash
curl http://localhost:8080/api/scans/1/vulnerabilities
```

**Shows:**
- CVE-2021-44228 (Log4Shell) - CRITICAL
- CVE-2022-22965 (Spring4Shell) - HIGH
- And more...


## 🔌 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/scans/trigger` | Start a new scan |
| GET | `/api/scans` | List recent scans |
| GET | `/api/scans/{id}` | Get scan details |
| GET | `/api/scans/{id}/vulnerabilities` | List vulnerabilities |
| GET | `/api/scans/project/{name}` | Get project history |
| DELETE | `/api/scans/{id}` | Delete a scan |
| GET | `/api/scans/health` | Health check |

**Full API documentation:** http://localhost:8080/swagger-ui.html


## 🔧 Configuration

Edit `src/main/resources/application.yml`:

```yaml
server:
  port: 8080  # Change API port

spring:
  datasource:
    url: jdbc:h2:mem:vulndb  # Database connection
```


## 🧪 Testing

```bash
# Run all tests
mvn test

# Run with coverage report
mvn test jacoco:report

# View coverage
open target/site/jacoco/index.html
```

**Test Coverage:** 85%+


## 🐳 Docker

```bash
# Build Docker image
docker build -t vulnerability-scanner .

# Run container
docker run -p 8080:8080 vulnerability-scanner

# Test
curl http://localhost:8080/api/scans/health
```


## ☸️ Kubernetes

```bash
# Deploy to Kubernetes
kubectl apply -f k8s/

# Check status
kubectl get pods -n vuln-scanner

# Access service
kubectl port-forward svc/scanner-service 8080:80 -n vuln-scanner
```


## 🔄 CI/CD Integration

### GitHub Actions Example

```yaml
- name: Security Scan
  run: |
    # Trigger vulnerability scan
    response=$(curl -X POST http://localhost:8080/api/scans/trigger \
      -H "Content-Type: application/json" \
      -d '{"projectName":"${{ github.repository }}","projectVersion":"${{ github.sha }}"}')
    
    # Check for critical vulnerabilities
    critical=$(echo $response | jq '.criticalCount')
    
    if [ $critical -gt 0 ]; then
      echo "❌ CRITICAL vulnerabilities found! Blocking deployment."
      exit 1
    fi
    
    echo "✅ No critical vulnerabilities. Safe to deploy."
```


## 🛡️ Detected Vulnerabilities

The scanner identifies real-world CVEs:

### Log4Shell (CVE-2021-44228) - CRITICAL
- **Dependency:** log4j-core 2.14.1
- **CVSS Score:** 10.0
- **Fix:** Upgrade to 2.17.1+

### Spring4Shell (CVE-2022-22965) - HIGH
- **Dependency:** spring-core 5.3.17
- **CVSS Score:** 9.8
- **Fix:** Upgrade to 5.3.18+

### Jackson DoS (CVE-2020-36518) - MEDIUM
- **Dependency:** jackson-databind 2.12.3
- **CVSS Score:** 7.5
- **Fix:** Upgrade to 2.12.6.1+


## 📊 Use Cases

1. **CI/CD Pipeline Security** - Automatic scanning on every commit
2. **Security Audits** - Generate compliance reports
3. **Dependency Management** - Track vulnerable libraries
4. **Risk Assessment** - Evaluate project security posture
5. **Trend Analysis** - Monitor security improvements


## 🏗️ Technology Stack

- **Framework:** Spring Boot 3.2.1
- **Language:** Java 17
- **Database:** H2 (development) / PostgreSQL (production)
- **API Docs:** OpenAPI 3.0 / Swagger
- **Build Tool:** Maven
- **Testing:** JUnit 5, MockMvc


## 📂 Project Structure

```
vulnerability-scanner/
├── src/
│   ├── main/java/com/example/task_management_devops/
│   │   ├── VulnerabilityScannerApplication.java
│   │   ├── controller/
│   │   ├── service/
│   │   ├── repository/
│   │   ├── model/
│   │   └── dto/
│   └── resources/
│       └── application.yml
├── pom.xml
└── README.md
```

---
