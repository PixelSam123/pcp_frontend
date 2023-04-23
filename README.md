# pcp_frontend

Pixel Code Platform frontend

---

## List of modifications to OS-specific builds

1. macOS

   Added this to both `Runner/DebugProfile.entitlements` and `Runner/Release.entitlements`:

   ```xml
   <key>com.apple.security.network.client</key>
   <true/>
   ```
