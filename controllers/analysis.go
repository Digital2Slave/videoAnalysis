package controllers

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"os"
	"regexp"
	"strings"
)

type AnalysisController struct {
	beego.Controller
}

func (this *AnalysisController) Get() {
	this.TplName = "analysis.tpl"
}

func (this *AnalysisController) Post() {
	f, h, err := this.GetFile("fileToUpload")
	// f, h, err := this.Ctx.Request.FormFile("fileToUpload")
	if err != nil {
		this.Data["json"] = map[string]interface{}{"result": false, "msg": "Sorry, upload failed in analysis!"}
		this.ServeJSON()
	}
	defer f.Close()

	// check format of uploaded video
	mime := h.Header.Get("Content-Type")
	logs.Debug(mime)
	ext := ".mp4"
	switch {
	case mime == "video/mp4":
		ext = ".mp4"
	case mime == "video/ogg":
		ext = ".ogg"
	case mime == "video/webm":
		ext = ".webm"
	case mime == "video/3gpp":
		ext = ".3gp"
	case mime == "video/quicktime":
		ext = ".mov"
	case mime == "video/x-flv":
		ext = ".flv"
	case mime == "application/x-mpegURL":
		ext = ".m3u8"
	case mime == "video/MP2T":
		ext = ".ts"
	case mime == "video/x-msvideo":
		ext = ".avi"
	case mime == "video/s-ms-wmv":
		ext = ".wmv"
	default:
		this.Data["json"] = map[string]interface{}{"result": false, "msg": "not support format " + ext}
		this.ServeJSON()
		return
	}

	storage := beego.AppConfig.String("storagepath")
	folder := this.GetString("filePath")
	fileName := h.Filename

	// 替换上传目标路径中的首尾斜杠
	reHead := regexp.MustCompile("^/+")
	reTail := regexp.MustCompile("/+$")
	folder = reHead.ReplaceAllString(folder, "")
	folder = reTail.ReplaceAllString(folder, "")

	// 防止目录层级过深
	if strings.Count(folder, "/") >= 9 { // 9表示超过10级子目录，太深了
		this.Data["json"] = map[string]interface{}{"result": false, "msg": "子目录层级过深，不可超过9级"}
		this.ServeJSON()
		return
	}

	// 创建上传文件目录
	err = os.MkdirAll(storage+folder, 0755)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"result": false, "msg": "创建上传文件目录失败"}
		this.ServeJSON()
		return
	}

	// 文件保存到本地
	err = this.SaveToFile("fileToUpload", storage+folder+"/"+fileName)
	if nil != err {
		this.Data["json"] = map[string]interface{}{"result": false, "msg": "保存上传文件失败"}
		this.ServeJSON()
		return
	}

	// ResOfTfModel := utils.RecognizeJt(storage + folder + "/" + fileName)  // TODO video analysis by tf model
	ResOfTfModel := "done"

	this.Data["json"] = map[string]interface{}{
		"isSuccess":    true,
		"ResOfTfModel": ResOfTfModel,
		"url":          folder + "/" + fileName, // 保存后的文件路径
	}
	this.ServeJSON()
}
