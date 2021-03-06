diff --git a/Redis.php.0 b/Redis.php
index 4d53402..01b81ad 100644
--- a/Redis.php.0
+++ b/Redis.php
@@ -19,7 +19,7 @@ if (class_exists('Redis')) {
 
         function establishConnection()
         {
-            $this->pconnect($this->host, (int)$this->port, (int)$this->timeout, getmypid());
+            $this->pconnect($this->host, (int)$this->port, (int)$this->timeout, (string)getmypid());
             if ($this->password !== null) {
                 $this->auth($this->password);
             }
