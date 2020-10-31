--- app/Model/Module.php.orig	2020-10-31 21:49:49.930554635 +0000
+++ app/Model/Module.php	2020-10-31 21:50:16.374965723 +0000
@@ -289,8 +289,8 @@
     {
         $modules = $this->getModules($moduleFamily);
         $result = array();
-        if (!empty($modules)) {
-            foreach ($modules as $module) {
+        if (!empty($modules['modules'])) {
+            foreach ($modules['modules'] as $module) {
                 if (array_intersect($this->__validTypes[$moduleFamily], $module['meta']['module-type'])) {
                     $moduleSettings = [
                         array('name' => 'enabled', 'type' => 'boolean'),
