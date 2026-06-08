# GemFire Dependency Bundler

This utility simplifies downloading Tanzu/Broadcom GemFire core dependencies, automatically reconstructing a standard local Maven (`.m2`) repository layout on the fly. It fetches the required `.jar` binaries, downloads their matching `.pom` metadata, calculates `.sha1` checksums, and bundles them into a clean, versioned ZIP file perfect for offline or air-gapped environment transfers.

---

## 🛠️ Prerequisites

* **Java JDK 8 or higher** installed and configured in your environment path.
* **Broadcom Artifactory Credentials** to access the Tanzu GemFire repository.
---

## 🚀 How to Use

Simply use the provided `Makefile` to control the entire workflow.

### 1. View the Help Screen
To see all available options, run:
```bash
make
```

### 2. Interactive Wizard Mode (Recommended)
To walk through the prompts for your credentials and target GemFire version, run:
```bash
make build
```
> **Tip:** If you have `GEMFIRE_ARTIFACTORY_USERNAME` and `GEMFIRE_ARTIFACTORY_PASSWORD` already exported in your environment variables, hitting **[ENTER]** at the prompts will automatically use them as defaults.

You can generate a registry token here: https://support.broadcom.com/group/ecx/registry-token

### 3. Automated Command Line Mode (CI/CD / Fast Execution)
To bypass the script prompts entirely and build instantly on a single line, provide your arguments to the execution path:
```bash
make build REPO_USER="your-email@company.com" REPO_PASS="your-token" VERSION="10.2.4"
```
*(If the `VERSION` parameter is omitted in this mode, it defaults to `10.2.4`)*

### 4. Cleaning Up
To wipe out temporary staging trees and build caches before your next download run:
```bash
make clean
```

---

## 📦 Output Bundle Breakdown

Once the build is successful, your generated ZIP file will be exported inside the project tree under:
`build/dist/gemfire-dependencys-<version>.zip`

When unzipped, it perfectly mimics a standard, deployment-ready `.m2` repository folder structure:

```text
└── com/
    └── vmware/
        └── gemfire/
            └── gemfire-core/
                └── 10.2.4/
                    ├── gemfire-core-10.2.4.jar
                    ├── gemfire-core-10.2.4.jar.sha1
                    ├── gemfire-core-10.2.4.pom
                    └── gemfire-core-10.2.4.pom.sha1
```

---

## 🔧 Troubleshooting

### PKIX Path Building Failed (SSL Handshake Error)

If you see an error like:

```
javax.net.ssl.SSLHandshakeException: PKIX path building failed:
sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target
```

This is typically caused by a corporate web proxy or security agent (such as **Symantec WSS**) intercepting SSL/TLS connections. The proxy presents its own certificate which Java's trust store doesn't recognize.

**Fix:** Disable the Symantec WSS agent (or equivalent corporate proxy/security agent) before running the build, then re-enable it afterward.

### HTTP 401 Unauthorized from Artifactory

If the build fails with `Received status code 401 from server` when resolving GemFire dependencies, this is an authentication failure against the Broadcom Artifactory repository.

**Possible causes:**
* **Transient server-side issue** — Artifactory may occasionally return a spurious 401. Simply retry the build with `make build`.
* **Incorrect credentials** — Double-check that your `GEMFIRE_ARTIFACTORY_USERNAME` and `GEMFIRE_ARTIFACTORY_PASSWORD` environment variables (or the values you entered at the prompts) are correct and that your Broadcom account has access to the GemFire repository.
* **Expired token** — If you are using an API token rather than a password, verify it has not expired.
