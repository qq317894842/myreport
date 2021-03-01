const $jm = {
    excelSave(data, token, callback){
        const saveFn = (obj) => {
            //判断报表是否有分组字段
            const rows = data.rows;
            let groupField = "";
            for (let key in rows) {
                if (groupField) break;
                const cells = rows[key].cells;
                for (let cellKey in cells) {
                    const text = cells[cellKey].text;
                    if (!text) continue;
                    if (text.includes(".group(")){
                        groupField = text.replace("group(", "")
                            .replace(")}", "")
                            .replace("#{", "")
                        break;

                    }
                }
            }
            if (groupField){
                data.isGroup = true;
                data.groupField = groupField;
            }
            if (data.chartList && data.chartList.length > 0){
                data.chartList.forEach(item => {
                    if (item.width === 0 || item.height === 0){
                        item.width = "650";
                        item.height = "350";
                    }
                })
            }
            let dataStr = JSON.stringify({designerObj: obj, ...data});
            if (obj.name != null && obj.name != ""){
                $http.post({
                    url: api.saveReport,
                    data: dataStr,
                    contentType:'json',
                    success:(result)=>{
                        onbeforeunload = "return true";
                        callback(result);
                    }
                })
            }
        }
        vm.handleCreate(saveFn, data);
    },
    excelGet(code,callback){
        if (code != null && code != ""){
            $http.get({
                url:api.getReport(code),
                success:(result)=>{
                    Vue.prototype.$Spin.hide();
                    if (result){
                        callback&&callback(result);
                    }
                }
            })
        }
    },
    excelView(id, requestParam, callback,fail,url){
        let apiUrl=url?url:'';
        $http.get({
            url:api.show,
            data: {"id": id, "apiUrl":apiUrl, "params": JSON.stringify(requestParam)},
            success:(result)=>{
                callback(result);
            },fail:(result)=>{
                fail&&fail(result);
            }
        })
    },
    addViewCount(id){
        $http.post({
            contentType:'json',
            url:api.addViewCount(id)
        })
    },
    checkParam(id, callback,fail){
        $http.get({
            url:api.checkParam(id),
            success:(result)=>{
                callback(result);
            },
            fail:(result)=>{
                fail&&fail(result)
            }
        })
    },
    async qurestSql(id, callback){
        await $http.get({
            url:api.qurestSql,
            data: {"apiSelectId": id},
            success:(result)=>{
                callback(result);
            }
        })
    },
    async qurestApi(id, callback){
        await $http.get({
            url:api.qurestApi,
            data: {"apiSelectId": id},
            success:(result)=>{
                callback(result);
            }
        })
    },
    qureyByApiUrl(url, callback){
        $http.get({
            url:url,
            success:(result)=>{
                callback(result);
            }
        })
    },
    //校验唯一性
    async dataCodeExist(id, code, callback){
        await $http.get({
            url:api.dataCodeExist,
            data: {"reportId": id, "code": code},
            success:(result)=>{
                callback(result);
            }
        })
    },
    //获取查询信息
    getQueryInfo(id, token, callback){
        $http.get({
            url:api.getQueryInfo,
            data: {"reportId": id},
            success:(result)=>{
                callback(result);
            }
        })
    }

};