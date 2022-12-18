package main
//一个超级简单的静态服务器，使用当前路径下的  html  文件夹，提供网页服务
//不必再安装nginx之类，使用"nohup ./webserver>>11.log& "运行，监听80端口
//服务器重启后需要手动再次运行
//结束进程使用：kill -9 `cat pidfile.txt`

import (
    "net/http"
    "fmt"
    "os"
    "path/filepath"
)

func main() {
	ex, err := os.Executable()
    if err != nil {
        panic(err)
    }
    exPath := filepath.Dir(ex)
    fmt.Println("webroot:" + exPath + "/html/")
    fmt.Println("nohup ./webserver > logfile.txt & echo $! > pidfile.txt")
    fmt.Println("kill -9 `cat pidfile.txt`")
    http.Handle("/", http.FileServer(http.Dir(exPath + "/html/")))
    http.ListenAndServe(":80", nil)
}