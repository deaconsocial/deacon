# Deacon

Describe your module.

### Notes

The Node streaming server needs the db server's certificate. I grabbed the cert from terraform output and saved it to `/home/mastodon/db.crt.` I then had to apply the following patch in order to allow the streaming server to authenticate the db server:

```diff
diff --git a/streaming/index.js b/streaming/index.js
index 6935c4764..1b6eb98e7 100644
--- a/streaming/index.js
+++ b/streaming/index.js
@@ -141,7 +141,10 @@ const startWorker = async (workerId) => {
 
   if (!!process.env.DB_SSLMODE && process.env.DB_SSLMODE !== 'disable') {
     pgConfigs.development.ssl = true;
-    pgConfigs.production.ssl = true;
+    pgConfigs.production.ssl = {
+      rejectUnauthorized: true,
+      ca: fs.readFileSync('/home/mastodon/db.crt'),
+    };
   }
 
   const app = express();
```

- Needed to do this to deal with two reverse proxies: https://github.com/mastodon/mastodon/issues/899
- Updated the number of threads and concurrency for Sidekiq to 8 in the systemd unit file.
  - We should have 2 Puma processes that each keep a db pool of 7 connections and a single sidekiq process with 8 connections.
