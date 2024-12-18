import time
import subprocess
import os
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# 配置
PROJECT_DIR = '/Users/jinliangyan/Documents/School/学校生活/我的作业/Web实验/大作业/xiaomifeng'  # 替换为您的Maven项目路径
WAR_FILE = os.path.join(PROJECT_DIR, 'target', 'servlet-1.0-SNAPSHOT.war')
TOMCAT_DEPLOY_DIR = '/opt/homebrew/Cellar/tomcat/10.1.33/libexec/webapps'  # 替换为Tomcat的webapps目录
TOMCAT_MANAGER_URL = 'http://localhost:8080/manager/text/deploy'  # Tomcat管理URL
TOMCAT_USER = 'hotreload'  # Tomcat管理用户名
TOMCAT_PASSWORD = 'hotreload'  # Tomcat管理密码

class ProjectEventHandler(FileSystemEventHandler):
    def __init__(self):
        super().__init__()
        self.last_package_time = 0
        self.last_deploy_time = 0

    def on_any_event(self, event):
        if event.is_directory:
            return

        # 检测项目文件变化，执行mvn clean package
        if not event.src_path.endswith('.war') and event.event_type in ['modified', 'created', 'deleted', 'moved']:
            current_time = time.time()
            # 防止频繁触发
            if current_time - self.last_package_time > 5:
                print("检测到项目文件变化，执行 mvn clean package")
                subprocess.run(['mvn', 'clean', 'package'], cwd=PROJECT_DIR)
                self.last_package_time = current_time

        # 检测WAR文件变化，执行部署
        if event.src_path == WAR_FILE and event.event_type in ['modified', 'created']:
            current_time = time.time()
            if current_time - self.last_deploy_time > 5:
                print("检测到WAR文件更新，开始部署到Tomcat")
                deploy_to_tomcat(WAR_FILE)
                self.last_deploy_time = current_time

def deploy_to_tomcat(war_path):
    # 使用Tomcat Manager进行部署
    import requests
    from requests.auth import HTTPBasicAuth

    war_name = os.path.basename(war_path)
    with open(war_path, 'rb') as f:
        war_data = f.read()

    # 首先，删除已有的应用（如果存在）
    undeploy_url = f"{TOMCAT_MANAGER_URL}?command=undeploy&path=/{war_name.replace('.war', '')}"
    response = requests.get(undeploy_url, auth=HTTPBasicAuth(TOMCAT_USER, TOMCAT_PASSWORD))
    if response.status_code == 200:
        print(f"已卸载旧的应用: {war_name}")
    else:
        print(f"卸载应用失败或应用不存在: {response.text}")

    # 部署新的WAR
    deploy_url = f"{TOMCAT_MANAGER_URL}?command=deploy&path=/{war_name.replace('.war', '')}&update=true"
    files = {'war': (war_name, war_data)}
    response = requests.put(deploy_url, files=files, auth=HTTPBasicAuth(TOMCAT_USER, TOMCAT_PASSWORD))
    if response.status_code == 200:
        print(f"成功部署WAR文件: {war_name}")
    else:
        print(f"部署WAR文件失败: {response.text}")

if __name__ == "__main__":
    event_handler = ProjectEventHandler()
    observer = Observer()
    observer.schedule(event_handler, path=PROJECT_DIR, recursive=True)
    observer.start()
    print("开始监控项目文件变化...")

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()