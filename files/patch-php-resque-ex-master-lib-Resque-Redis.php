--- Redis.php.0	2021-03-07 17:22:34.893788318 +0000
+++ Redis.php	2021-03-07 17:24:35.120737618 +0000
@@ -20,7 +20,7 @@
 
 		function establishConnection()
 		{
-			$this->pconnect($this->host, (int) $this->port, (int) $this->timeout, getmypid());
+			$this->pconnect($this->host, (int) $this->port, (int) $this->timeout, (string)getmypid());
 			if ($this->password !== null) {
 				$this->auth($this->password);
 			}
