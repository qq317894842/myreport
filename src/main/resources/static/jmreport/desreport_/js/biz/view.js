const view = {
    origin:window.location.origin
 }
// 预览页面 vue实例
 let rpViewInst = new Vue({
     el: "#app",
     data: function () {
         return {
             loading: false,
             visible: false,
             //报表参数选项列表
             reportParamList:[],
             //查询参数对象
             reportParamObj:{

             },
             callback:'',
             configQueryList:[],
             //查询对象
             tokenKey:'X-Access-Token',
             queryInfo:{

             },
             timerArr:[]
         }
     },
     created(){
         this.resetQueryInfo()
     },
     methods:{
         //获取查询控件描述
         getQueryItemLabel(item){
             if(item.duplicate===true){
                 return item.title+'('+item.dbText+'):'
             }else{
                 return item.title+':'
             }
         },
         resetQueryInfo(){
             Object.keys(this.queryInfo).map(k=>{
                 if(k!=this.tokenKey){
                     this.queryInfo[k] = ''
                 }
             })
         },
         //重置
         resetReportQuery(){
             this.resetQueryInfo()
             this.doReportQuery()
         },
         //获取查询条件
         getRpQueryParam(){
             let requestParam = getRequestUrl();
             if(!requestParam['pageNo']){
                 requestParam['pageNo'] = 1
             }
             query2RequestParam(this.queryInfo, requestParam);
             return requestParam
         },
         //查询
         doReportQuery(){
             console.log('查询条件', this.queryInfo)
             Vue.prototype.$Spin.show();
             let requestParam = this.getRpQueryParam();
             $jm.excelView(view.excelConfigId, requestParam, (result)=> {
                 Vue.prototype.$Spin.hide();
                 var str = result.jsonStr;
                 if(!str){
                     xs.loadData({});
                     return;
                 }

                 let json = JSON.parse(str)
                 let dataMap = result.dataList
                 let expData = {...dataMap['expData']}
                 delete dataMap['expData']
                 str = handleChartData(dataMap, str)
                 const dealDataList = view.dealDataList(dataMap);
                 const dataList = dealDataList.dataList;
                 const count = dealDataList.count;
                 const pageObj = dealDataList.pageObj;
                 const excelDataList = view.getExcelData(dataList);
                 let json1 = JSON.parse(str)
                 const viewData = view.parseData(str,excelDataList);
                 let json2 = JSON.parse(str)
                 if(expData && "{}"!=JSON.stringify(expData)){
                     xs.setExpData(expData);
                 }
                 if(Object.keys(pageObj).length===1){
                     xs.data.settings.page = 1;
                     xs.data.settings.total = pageObj[Object.keys(pageObj)[0]];
                     if(xs.data.settings.total==1){
                         //下一页和最后一页禁用
                         xs.sheet.rpbar.btn_next.btn.el.disabled=true;
                         xs.sheet.rpbar.btn_end.btn.el.disabled=true;
                     }
                 }
                 xs.sheet.rpbar.btn_input.countSpan.el.innerHTML=xs.data.settings.total;
                 xs.loadData(viewData);


             },(res)=>{
                 Vue.prototype.$Message.warning(!res.message?'查无数据':res.message);
                 xs.loadData({});
             });
         },
         //日期组件值改变事件
         handleQueryDateChange(str, key){
             this.queryInfo[key] = str
         },
         //下拉多选改变
         handleQueryMultiSelectChange(arr, key){
             console.log(key, arr)
             if(!arr || arr.length==0){
                 this.queryInfo[key] = ''
             }else{
                 this.queryInfo[key] = arr.join(',')
             }
         },
         show(reportParamList, callback){
             this.reportParamList = [...reportParamList];
             this.visible=true;
             let obj = {};
             for(let item of reportParamList){
                 if(!item.paramValue || item.paramValue.length==0){
                     obj[item.paramName] = '';
                 }else{
                     obj[item.paramName] = item.paramValue;
                 }
             }
             this.reportParamObj = obj;
             this.callback = callback;
             //console.log('show', reportParamList)
         },
         onSave() {
             //console.log('this.paramobj', this.reportParamObj);
             this.callback(this.reportParamObj);
             this.visible=false;
             Vue.prototype.$Spin.show();
         }
     }
 })
 //方便前端调试
 if(getRequestUrl().develop=='true'){
     view.origin=getRequestUrl().origin;
 }
 const reg = /{([a-zA-Z0-9_\u4e00-\u9fa5]+).(\S+)}/
 let xs = null;
 window.onresize=()=>{
     //窗口大小改变后，设置图片上边距
     setTimeout(() => {
         view.dealPicTop();
         changeScrollBottom();
     }, 1);

 }
 view.load = function(excelConfigId){
     Vue.prototype.$Spin.show();
     //拿到token
     let token = window.localStorage.getItem('JmReport-Access-Token');
     if (token == "" || token == null || "undefined"==token){
         token = getRequestUrl().token;
         window.localStorage.setItem('JmReport-Access-Token',token);
     }
     view.token = token;
     console.log("view_view--------------",view.token);
     view.excelConfigId = excelConfigId;
     const options = {
         "viewLocalImage":"/jmreport/img",//预览本地图片方法
         domain:baseFull,
         rpBar: true,
         showToolbar:false ,     //头部操作按钮
         showGrid: false,        //excel表格
         showContextmenu: false, //右键操作按钮
         readOnly:true,
         view: {
             height: () => document.documentElement.clientHeight - 40,
             width: () => document.documentElement.clientWidth,
         },
         row: {
             len: 100,
             height: 25,
         },
         col: {
             len: 50,
             width: 100,
             minWidth: 60,
             height: 0,
             indexWidth: 0,
         },
         style: {
             bgcolor: '#ffffff',
             align: 'left',
             valign: 'middle',
             textwrap: false,
             strike: false,
             underline: false,
             color: '#0a0a0a',
             font: {
                 name: 'Helvetica',
                 size: 10,
                 bold: false,
                 italic: false,
             },
         },
     };
     //x.spreadsheet.locale('zh-cn');
     const requestParam = getRequestUrl();
     let jmdata=requestParam.jmdata;
     // 下载oss图片到本地
     options.downLoadImage = (imageUrl)=>{
         return axios.get(`${options.domain}/jmreport/download/image?imageUrl=${imageUrl}`)
     }
     if(jmdata){
         options.total = 1;
         xs = x.spreadsheet('#jm-sheet-wrapper', options)
         const excelData = JSON.parse(decodeURIComponent(jmdata));
        xs.data.rows._={}
        xs.data.cols._={};
        xs.data.styles=[];
        xs.loadData(excelData);
     }else{
         handleReportQueryInfo(token);
         let page=1;
         let total = 1;
         options.pageInfo={
             url:`${baseFull}/jmreport/show`,
             data:{
                 "id":excelConfigId,
                 "params":requestParam
             }
         }
         var loadExcelView = function(inputparam){
             if(inputparam){
                 Object.keys(inputparam).map(key=>{
                     requestParam[key] = inputparam[key]
                     if(key=='pageNo'){
                         page = Number(inputparam[key])
                     }
                 })
             }
             view.dictInfo = []
             requestParam.pageNo = page;
             query2RequestParam(rpViewInst.queryInfo, requestParam);
             console.log('requestParam', requestParam)

             $jm.excelView(excelConfigId,requestParam,(result)=> {
                    //设置网页标题
                     document.title = result.name;
                     var str = result.jsonStr;
                     if(!str){
                         xs.loadData({});
                         return;
                     }
                     // getDataById 查询出来的 MAP MAP MAP 不是list
                     let dataMap = result.dataList
                 console.info("test",dataMap);
                     let expData = {...dataMap['expData']}
                     delete dataMap['expData']
                     //预览运行图表数据
                     str = handleChartData(dataMap, str)
                     //获取分页参数
                     const dealDataList = view.dealDataList(dataMap);
                     const dataList = dealDataList.dataList;
                     const count = dealDataList.count;
                     const pageObj = dealDataList.pageObj;
                     //获取数据集
                     const excelDataList = view.getExcelData(dataList);
                     view.dictInfo = result.dictInfo
                     if(Object.keys(pageObj).length===1){
                         total = pageObj[Object.keys(pageObj)[0]];
                         options.getPageResult = getPageResult
                     }
                     options.count = count;
                     options.pdfName = result.name;
                     options.page = page;
                     options.total = total;

                     const printAllFlag=encodeURIComponent(JSON.stringify({'printAll':true,'X-Access-Token':view.token}));
                     options.getAll=`${baseFull}/jmreport/show?id=${excelConfigId}&params=${printAllFlag}`;
                     //查找全部数据接口
                     options.getAllFn=function (p) {
                         let arg = {'printAll':true,'X-Access-Token':view.token}
                         if(p){
                             Object.keys(p).map(k=>{
                                 if(p[k]){
                                     arg[k] = p[k]
                                 }
                             })
                         }
                         let paramString = encodeURIComponent(JSON.stringify(arg))
                         let getAllUrl = `${baseFull}/jmreport/show?id=${excelConfigId}&params=${paramString}`;
                         return axios.get(getAllUrl);
                     };

                     //多页打印回调函数
                     options.parseDataFn=view.parseData;
                     options.dealManySourceFn=dealManySource;
                     const requestParamObj = getRequestUrl();
                     let requestStr=``;
                     if(requestParamObj){
                         for(let key in requestParamObj){
                             requestStr+=(requestStr.includes("?")?`&`:`?`)+`${key}=${requestParamObj[key]}`
                         }
                         requestStr+=(requestStr.includes("?")?`&`:`?`)+`token=${token}`
                     }
                     var base64Arry = [];
                     //console.log('--options',JSON.stringify(options))
                     xs = x.spreadsheet('#jm-sheet-wrapper', options)
                         .onSettingEvent(function (e) {
                            if(e=='pdf'){
                                //导出pdf需要获取参数
                                let exportParam = rpViewInst.getRpQueryParam();
                                xs.exportPdf(exportParam)
                            }
                         })
                         .onExportExcelAll(function(){
                             //导出全部excel
                             //window.open(baseFull+`/jmreport/exportAllExcel/${excelConfigId}?token=${token}`);
                             xs.getLayerBase64().then(values=>{
                                 base64Arry = values;
                                 var dataStr = '';
                                 let queryParam  = rpViewInst.getRpQueryParam();
                                 if (base64Arry != null && base64Arry.length > 0){
                                     dataStr = JSON.stringify({excelConfigId:excelConfigId,base64Arry:base64Arry,queryParam: queryParam});
                                 }else {
                                     dataStr = JSON.stringify({excelConfigId:excelConfigId, queryParam:queryParam});
                                 }
                                 Vue.prototype.$Spin.show();
                                 $http.post({
                                     contentType:'json',
                                     url:api.exportAllExcel,
                                     data : dataStr,
                                     success:(result)=>{
                                         ajaxFileDownload(result.file, result.name);
                                     },
                                     error:(e)=>{
                                         Vue.prototype.$Spin.hide();
                                         xs.tip(e.error);
                                     }
                                 })
                             })
                         });
                     if(expData && "{}"!=JSON.stringify(expData)){
                         xs.setExpData(expData);
                     }
                     let finalJsonObj = JSON.parse(str);
                     if(finalJsonObj.chartList && finalJsonObj.chartList.length >0){
                         finalJsonObj.chartList.forEach(function(item){
                             let config = JSON.parse(item.config);
                             //处理地图信息
                             if (config.geo){
                                 $http.post({
                                     contentType:'json',
                                     url:api.queryMapByCodeUseOrigin,
                                     data:JSON.stringify({name:config.geo.map,reportId: view.excelConfigId}),
                                     success:(result)=>{
                                         let data=JSON.parse(result.data);
                                         if(item.extData && item.extData.dbCode){
                                             item.extData.mapData = data;
                                             //图表刷新
                                             let isTiming = item.extData.isTiming;//是否开启定时刷新
                                             if(isTiming){
                                                 let intervalTime = item.extData.intervalTime; //刷新时间
                                                 let timer=setInterval(function(){
                                                     //数据刷新
                                                     refreshData(item,dataMap)
                                                 },intervalTime * 1000);
                                             }
                                         }
                                         xs.registerMap(result.name,data);
                                         xs.updateChart(item.layer_id ,config);
                                     }
                                 })
                             }
                             //判断图表设置定时刷新
                             else if(item.extData && item.extData.dbCode){
                                 //图表刷新
                                 let isTiming = item.extData.isTiming;//是否开启定时刷新
                                 if(isTiming){
                                     let intervalTime = item.extData.intervalTime; //刷新时间
                                     let timer=setInterval(function(){
                                         //数据刷新
                                         refreshData(item,dataMap)
                                     },intervalTime * 1000);
                                     rpViewInst.timerArr.push(timer)
                                 }
                             }
                         })
                     }
                     view.viewReport(str,excelDataList);
                     Vue.prototype.$Spin.hide();

             },(res)=>{
                 Vue.prototype.$Spin.hide();
                 Vue.prototype.$Message.warning(res.message);
             })
         }

         //先校验 参数 再
         $jm.checkParam(excelConfigId,(result)=>{
             Vue.prototype.$Spin.hide();
             let requestUrlParam = getRequestUrlParam();
             if(reportMode=='dev'){
                 // 判断地址参数是否和数据库参数匹配
                 var match = dbParamMatchUrlParam(result, requestUrlParam)
                 if(match){
                     //如果匹配 则直接显示报表
                     loadExcelView(requestUrlParam)
                 }else{
                     //如果不匹配 则弹框 需要用户填写相关参数
                     rpViewInst.show(result, loadExcelView);
                     //  loadExcelView()
                 }
             }else{
                 let dbParam = {}
                 for(let item of result){
                     dbParam[item.paramName] = item.paramValue
                 }
                 let inputparam = Object.assign(dbParam, requestUrlParam)
                 loadExcelView(inputparam)
             }
         },(res)=>{
             //无参数
             loadExcelView();
         })
     }

     //增加访问次数
     $jm.addViewCount(excelConfigId);

 }
 view.getExcelData=function(dataList){
     const excelDataList = {};
     for(let key in dataList){
         const dataObj = dataList[key];
         if(!dataObj){
             continue;
         }
         if(!dataObj.list){
             excelDataList[key] = []
             excelDataList[`${key}_isPage`] =dataObj['isPage'];
         }else{
             excelDataList[key] = JSON.parse(JSON.stringify(dataObj.list));
             excelDataList[`${key}_isPage`] =dataObj['isPage'];
         }

     }
     return excelDataList;
 }
 /**
  * 获得分页信息
  * @param {} resultList
  */
 view.dealDataList=function(resultList){
     //处理之前老数据,只有一个数据源，
     if(Object.keys(resultList).length==1){
          let dataKey = Object.keys(resultList)[0];
          let dataObj = resultList[dataKey];
          if(!dataObj.isPage && dataObj.total>1){
              dataObj['isPage']='1';
          }
     }
     const dataList = JSON.parse(JSON.stringify(resultList));
     let count = 1;
     const pageObj = {}
     Object.keys(dataList).forEach(key=>{
         const dataObj = dataList[key];
         Object.keys(dataObj).forEach(resultKey=>{
             if(resultKey.endsWith("total")){
                 //是否是分页数据集
                 if(dataObj[`isPage`]=='1' &&dataObj['list'].length>1){
                     count = dataObj[`count`];
                     pageObj[key] = dataObj['total'];
                 }
                 delete dataObj['total'];
                 delete dataObj['count'];
             }
         })
     });
     return {
         dataList,
         count,
         pageObj
     }
 }

 // 将表达式的json数据转化成真实数据
 view.parseData = function(str,dataList,isPrint=false){
     //console.log('+++++++++++++++++++++++++++++++++')
     //console.log(str)
     //console.log('数据集',dataList)
     let strObj = JSON.parse(str);
     if(!dataList || JSON.stringify(dataList) == '{}') {
         return strObj
     }
     //console.log('----------------------------')
     if(isPrint){
         dataList = view.dealDataList(dataList);
         dataList = view.getExcelData(dataList.dataList);
     }
     Object.keys(dataList).forEach(key=>{
         delete dataList[`${key}_count`]
         if(key.endsWith("_total")){
             delete  dataList[key]
         }
     });
     //将数据里的key转成小写
     Object.values(dataList).forEach(item=>{
        item instanceof Array && item.forEach(row=>{
             Object.keys(row).forEach(key=>{
                 const lowerKey = key.toLowerCase();
                 if (lowerKey != key) {
                     row[lowerKey] = row[key];
                     delete row[key];
                 }
             })
         })
     });
     const dataListLen = Object.keys(dataList)
          .filter(item=>!item.endsWith('_isPage'))
          .length
     if(dataListLen==1){
         // 有一个数据集，并且数据集中只有一条记录
         let resultArray = Object.values(dataList);
         if(!resultArray) return
         const dataArryLen = resultArray[0].length
         if(dataArryLen==1){
            // strObj = dealOneData(strObj,dataList)
         }else if(dataArryLen>1){
             //strObj =  dealManySource(strObj,dataList)
         }else {
             //strObj = dealNoData(strObj)
         }
     }else if(dataListLen>1){
         //strObj = dealManySource(strObj,dataList)
     }
     // 字典数据处理
     //dictDataHandler(strObj);
     //console.log('----------------------------')
     console.log('数据对象',strObj)
     console.log('解析后内容',JSON.stringify(strObj.rows));
     //console.log('----------------------------')
     return strObj;
 }
 view.dealPicTop=function(){
     if(!xs) return;
     const imageData = xs.data.imgList;
     if(!imageData) return;
     //判断是否有套打图片,处理套打图片对不上问题
     const isBackend = imageData.some(item=>item.isBackend)
     if(isBackend){
      //   const $content = $(".x-spreadsheet-overlayer-content")[0];
        // $content.style.top='0px';
     }
 }
 view.viewReport = function(str,dataList,type){
     const viewData = view.parseData(str,dataList);
     if(type==='rpchange'){
         viewData.imgList = []
         viewData.chartList = []
     }
     xs.loadData(viewData);
     view.dealPicTop();
 }


function ajaxFileDownload(data,filename) {
    var a = document.createElement('a');
    var bstr = atob(data), n = bstr.length, u8arr = new Uint8Array(n);
    while (n--) {
        u8arr[n] = bstr.charCodeAt(n);
    }
    var blob =  new Blob([u8arr], { type: "application/octet-stream" });
    var url = window.URL.createObjectURL(blob);
    a.href = url;
    a.download = filename;
    a.click();
    window.URL.revokeObjectURL(url);
    Vue.prototype.$Spin.hide();
}

 //图表预览替换查询SQL数据
function querySqlData(echartJson,sqlxAxis,sqlseries,sqlgroup,sqltype,result){
    let charType = echartJson.series[0].type;
    let resultArr=JSON.parse(JSON.stringify(result));//记录结果集数据
    if (charType === 'bar' || charType === 'line'){
        let xAxisData = [];
        let seriesData = [];
        let legendData = [];//图例数据
        result.forEach(item=>{
            for(var d in item) {
                if (xAxisData.indexOf(item[d]) != -1){
                    let index = xAxisData.indexOf(item[d]);
                    seriesData[index] = seriesData[index] + item[sqlseries];
                    delete item[sqlseries];
                }else {
                    if (d === sqlxAxis){
                        xAxisData.push(item[d]);
                    }
                    if (d === sqlseries){
                        seriesData.push(item[d]);
                    }
                    if (d === sqlgroup && legendData.indexOf(item[d]) == -1){
                        legendData.push(item[d]);
                    }
                }
            }
        });
        echartJson.xAxis.data = xAxisData;
        //图例数据大于0，多组分类数据
        if(legendData.length>1){
            //处理分组数据
            let series=[];
            legendData.forEach((name,index)=>{
                //获取series公共样式
                let seriesStyle = echartJson.series.filter(item=>item.name==name);
                //let commonObj=Object.assign(echartJson.series[0],{name:name,data:[]});
                let commonObj=Object.assign(seriesStyle[0],{name:name,data:[]});
                let seriesObj=JSON.parse(JSON.stringify(commonObj));
                //获取series的data数据集
                for(let item of resultArr){
                    if(seriesObj.data.length==xAxisData.length){
                        break;
                    }
                    if(item[sqlgroup] == name){
                        seriesObj.data.push(item[sqlseries]);
                    }
                }
                series[index]=seriesObj;
            });
            console.log("series===>",series);
            echartJson.series=series;
        }else{
            echartJson.series[0].data = seriesData;
        }
        return echartJson;
    }else if (charType === 'pie'){
        let objpie = [];
        result.forEach(item=>{
            var objres = {};
            for(var d in item) {
                if (d === sqlxAxis){
                    objres['name'] = item[d];
                }
                if (d === sqlseries){
                    objres['value'] = item[d];
                }
            }
            objpie.push(objres);
        });
        let colorList=echartJson.series[0].data.map(item=>{return item.itemStyle;});
        echartJson.series[0].data = mergeObject(objpie);
        console.log('colorList',colorList);
        echartJson.series[0].data.forEach((item,index)=>{
            item.itemStyle=colorList[index];
        });
        return echartJson;
    }else if(charType === 'scatter'){
        echartJson.series[0].data = result.map(item=>{
            return [item[sqlxAxis],item[sqlseries]]
        });
        return obj;
    }
}
//图表预览替换查询api数据
function queryApiData(echartJson,result){
    let charType = echartJson.series[0].type;
    if (charType === 'bar' || charType === 'line'){
        let xAxisData = [];
        let seriesData = [];
        result.data.forEach(item=>{
            for(var d in item) {
                if (d === 'name'){
                    xAxisData.push(item[d]);
                }
                if (d === 'value'){
                    seriesData.push(item[d]);
                }
            }
        });
        echartJson.xAxis.data = xAxisData;
        //包含分类多组数据处理
        if(result.category){
            let series=[];
            //设置图例数据
            let obj=JSON.parse(JSON.stringify(echartJson.series));
            result.category.forEach((name,index)=>{
                //获取series默认样式
                let commonObj=Object.assign(echartJson.series[0],{name:name,data:[]});
                //判断原有样式是否存在
                let hasSeries = obj.filter(item=>item.name === name);
                if(hasSeries!=null && hasSeries.length>0) {
                    commonObj=Object.assign(hasSeries[0],{name:name,data:[]});
                }
                //多种图表的series公共样式获取
                 /*if(result.type && result.type.length>0){
                     let filter = obj.filter(serie=>serie.type == result.type[index]);
                     if(filter&&filter.length>0){
                         //设置一个默认样式
                         commonObj=Object.assign(filter[0],{name:name,data:[]});
                         //设置已经存在的样式
                         let hasSeries = filter.filter(item=>item.name === name);
                         if(hasSeries!=null && hasSeries.length>0) {
                             commonObj=Object.assign(hasSeries[0],{name:name,data:[]});
                         }
                     }
                 }*/
                let seriesObj=JSON.parse(JSON.stringify(commonObj));
                //获取series的data数据集
                seriesObj.data=seriesData.map(item=>{
                    return item[index]
                });
                series[index]=seriesObj;
            });
            echartJson.series=series;
        }else{
            echartJson.series[0].data = seriesData;
        }
        return echartJson;
    }else if (charType === 'pie'){
        //饼图数据替换、自定义颜色替换
        let colorList=echartJson.series[0].data.map(item=>{return item.itemStyle;});
        console.log('colorList',colorList);
        echartJson.series[0].data = result.data;
        if(echartJson.series[0].data.length>0){
            echartJson.series[0].data.forEach((item,index)=>{
                item.itemStyle=colorList[index];
            });
        }
        return echartJson;
    }else if(charType === 'scatter'){
        echartJson.series[0].data = result.data.map(item=>{return [item.name,item.value]});
        return obj;
    }else if(charType === 'map'){
        echartJson.data=result.data;
        return echartJson;
    }
}

//数组对象去重
function mergeObject(array) {
    var arrayFilted = [];
    array.forEach(value=>{
        if ( arrayFilted.length == 0 ) {
            arrayFilted.push(value);
        }else{
            let flag = true;
            arrayFilted.forEach(valueIndex=>{
                if (valueIndex.name && valueIndex.name === value.name) {
                    valueIndex.value = valueIndex.value + value.value;
                    flag = false;
                }
            });
            if (flag){
                arrayFilted.push(value);
            }
        }
    });
    return arrayFilted;
}

 /**
  * 单条数据
  * @param strObj
  * @param dataList
  * @returns {*}
  */
 function dealOneData(strObj,dataList) {
     // 有一个数据集，并且数据集中只有一条记录，详情表单
     let resultArray = Object.values(dataList);
     let dbsArray = Object.keys(dataList)
     let  resultList = resultArray[0][0];
     let excelRows = strObj.rows;
     for(let rowKey in excelRows){
         let cells = excelRows[rowKey].cells;
         if(!cells) continue;
         for(let cellKey in cells){
             let cell = cells[cellKey];
             let text  = cell.text;
             if(reg.test(text)){
                 let dbs = text.match(reg)[1]
                 if(dbsArray.indexOf(dbs)>=0){
                     const cellText = resultList[text.match(reg)[2]] || "";
                     cell.text = ''+cellText;
                 }
             }
         }
     }
     return strObj;
 }

/**
 * 解析 数据
 * @param height
 * @param startRowNum
 * @param dataCells
 * @param resultDataList
 * @returns {{}|[]}
 */
 function getRowData(height,startRowNum,dataCells,resultDataList){
    if(!resultDataList) return {};
    let rowData = {};

    //判断有无分组
    let dataCellsFlag = 0;
    let dataRightFlag = 0;
    for (let cellIndex in dataCells){
        //合计
        if (dataCells[cellIndex].aggregate === "group"){
            dataCellsFlag++;
        }
        //方向
        if (dataCells[cellIndex].direction === "right"){
            dataRightFlag++;
        }
    }
    //处理数据
    let newresultList = [];
    const groupObj=[];
    const mergesArr=[];
    let maxRowNum = startRowNum;
    let groupStartNum = maxRowNum;
    if (dataCellsFlag === 0 && dataCellsFlag === 0 && dataRightFlag === 0){
        //列表数据
        rowData = backSelectData(resultDataList,dataCells,maxRowNum,rowData,height, mergesArr)
    }else if (dataCellsFlag > 0 && dataRightFlag == 0){
        //分组数据 maxRowNum 行数
        newresultList = backGroupData(dataCellsFlag,dataCells,resultDataList,newresultList,groupObj)
        backSelectData(newresultList,dataCells,maxRowNum,rowData,height)
        //设置合并单元格
        let maxendRowNum = startRowNum + newresultList.length;
        for(let key in groupObj){
            if (maxRowNum >= maxendRowNum){
                maxRowNum = groupStartNum;
            }
            let cellIndex = groupObj[key].cellIndex;
            const count = groupObj[key].count;
            const cell = rowData[maxRowNum].cells[cellIndex];
            if (count>1){
                cell.merge = [count-1,0];
            }
            maxRowNum =  maxRowNum+1;

            //将合并的单元格merge添加到数组里
            if (count>1){
                let letter = String.fromCharCode(64 + parseInt(cellIndex+1));
                let endsite = count+maxRowNum-1;
                let mergelocat = letter+maxRowNum+':'+letter+endsite;
                mergesArr.push(mergelocat);
            }
            //将分组后的多余数据删除
            for (let m = 1; m < count; m++) {
                rowData[maxRowNum] && delete  rowData[maxRowNum].cells[cellIndex];
                maxRowNum++;
            }
        }
    }else if (dataRightFlag > 0){
        //分组数据 maxRowNum 列数
        newresultList = backGroupData(dataRightFlag,dataCells,resultDataList,newresultList,groupObj)
        backSelectRightData(newresultList,dataCells,maxRowNum,rowData,height);
        //设置合并单元格
        let maxendRowNum = startRowNum + newresultList.length;
        for(let key in groupObj){
            if (maxRowNum >= maxendRowNum){
                maxRowNum = groupStartNum;
            }
            let cellIndex = groupObj[key].cellIndex;
            const count = groupObj[key].count;
            const cell = rowData[cellIndex].cells[maxRowNum];
            if (count>1){
                cell.merge = [0,count-1];
            }
            maxRowNum =  maxRowNum+1;
            for (let m = 1; m < count; m++) {
                rowData[cellIndex] && delete  rowData[cellIndex].cells[maxRowNum];
                maxRowNum++;
            }
        }
    }
    //将分组的数据和合并的数组返回
    let arrmap = [];
    if (mergesArr.length > 0){
        arrmap["mergesArr"] = mergesArr;
    }
     arrmap["rowData"] = rowData;
    return arrmap;
 }

 //处理分组数据
function backGroupData(dataCellsFlag,dataCells,resultDataList,newresultList,groupObj){
    var listgroup = [];
    let isProcessed = true;
    let listgroupSize = 0;
    for (let cellIndex in dataCells){
        if(!dataCells[cellIndex].text) continue;
        if (dataCells[cellIndex].text.indexOf("group(") != -1 || dataCells[cellIndex].text.indexOf("groupRight(") != -1 ) {
            let cellMe = subStringStr(dataCells[cellIndex].text, "#{", "}").split(".")[1];
            let field = "";
            if (dataCells[cellIndex].text.indexOf("group(") != -1 ){
                field = subStringStr(cellMe, "group(", ")");
            }else if(dataCells[cellIndex].text.indexOf("groupRight(") != -1 ){
                field = subStringStr(cellMe, "groupRight(", ")");
            }
            //一个字段分组
            if (dataCellsFlag === 1){
                listgroup = util.arrayGroupBy(resultDataList,field);
                listGroupFe(listgroup,groupObj,field,cellIndex);
                for (let i = 0; i < listgroup.length; i++) {
                    newresultList.push.apply(newresultList,listgroup[i]);
                }
            }else if (dataCellsFlag > 1){
                //多个字段分组
                if(isProcessed){
                    //第一次分组
                    listgroup = util.arrayGroupBy(resultDataList,field);
                    listGroupFe(listgroup,groupObj,field,cellIndex);
                    listgroupSize = listgroup.length;
                }else {
                    //其余字段分组
                    var listgroupThree = [];
                    newresultList = [];
                    for (let i = 0; i < listgroupSize; i++) {
                        var listgroupTwo = [];
                        listgroupTwo = util.arrayGroupBy(listgroup[i],field);
                        listGroupFe(listgroupTwo,groupObj,field,cellIndex);
                        for (let j = 0; j < listgroupTwo.length; j++) {
                            listgroupThree.push(listgroupTwo[j]);
                        }
                    }
                    //将分组数据合并为集合
                    listgroup = listgroupThree;
                    listgroupSize = listgroup.length;
                    for (let i = 0; i < listgroupThree.length; i++) {
                        newresultList.push.apply(newresultList,listgroupThree[i]);
                    }
                }
            }
            isProcessed = false;
        }
    }
    return newresultList;
}

//将需要合并的个数和列位置记录
function listGroupFe(listgroup,groupObj,field,cellIndex){
    listgroup.forEach(listItem=>{
        const groupFieldObj = {};
        groupFieldObj.count = listItem.length;
        groupFieldObj.cellIndex = Number(cellIndex);
        groupObj.push(groupFieldObj);
    })
    return groupObj;
}

//将数据提取为rows中的格式
function backSelectData(resultDataList,dataCells,maxRowNum,rowData,height, mergesArr){
    for (let i = 0; i < resultDataList.length; i++) {
        let resultObj = resultDataList[i];
        let newCellObj={};
        for (let cellIndex in dataCells){
            let tempCell = {...dataCells[cellIndex]}
            if(tempCell.virtual){
                if(i>0){
                    delete tempCell['virtual']
                }
            }
            let text = tempCell.text;
            newCellObj[cellIndex] = tempCell
            if(reg.test(text)){
                if (text.match(reg)[2].indexOf("group(") != -1){
                    let field2 = subStringStr(text.match(reg)[2],"group(",")");
                    text = resultObj[field2] || "";
                    newCellObj[cellIndex].text = text;
                }else {
                    text = resultObj[text.match(reg)[2]] || "";
                    newCellObj[cellIndex].text = text;
                }
            }

            if(mergesArr){
                if(dataCells[cellIndex].merge){
                    let arr = dataCells[cellIndex].merge
                    if(arr && arr.length>0){
                        let charCode = parseInt(cellIndex)+ 64 + 1
                        let letter = String.fromCharCode(charCode);
                        let letter2 = String.fromCharCode(charCode+parseInt(arr[1]));
                        let mergeCode = letter+(maxRowNum+1)+':'+letter2+(maxRowNum+1)
                        mergesArr.push(mergeCode)
                    }
                }
            }

        }
        rowData[maxRowNum] = {};
        rowData[maxRowNum].height = height;
        rowData[maxRowNum].cells=newCellObj;
        maxRowNum++;
    }
    return rowData;
}

function backSelectRightData(resultDataList,dataCells,maxRowNum,rowData,height){
    for (let cellIndex in dataCells){
        var dataRight = [];
        rowData[cellIndex] = {};
        rowData[cellIndex].height = height;
        let startMaxRowNum = maxRowNum;
        for (let i = 0; i < resultDataList.length; i++) {
            let newCellObj={};
            newCellObj[startMaxRowNum] = {...dataCells[cellIndex]};
            let text = newCellObj[startMaxRowNum].text;
            let resultObj = resultDataList[i];
            if(reg.test(text)){
                if (text.match(reg)[2].indexOf("groupRight(") != -1){
                    let field2 = subStringStr(text.match(reg)[2],"groupRight(",")");
                    let textfield = resultObj[field2] || "";
                    newCellObj[startMaxRowNum].text = textfield;
                }else {
                    let textfield = resultObj[text.match(reg)[2]] || "";
                    newCellObj[startMaxRowNum].text = textfield;
                }
            }
            rowData[cellIndex].cells =  newCellObj;
            dataRight.push(rowData[cellIndex].cells);
            startMaxRowNum++;
        }
        for (let dataRightindex in dataRight){
            rowData[cellIndex].cells = { ...rowData[cellIndex].cells,...dataRight[dataRightindex]};
        }
    }
    return rowData;
}



//截取字符串方法
function subStringStr(str,strStart,strEnd){
    let strStartIndex = str.indexOf(strStart);
    let strEndIndex = str.indexOf(strEnd);
    if (strStartIndex < 0) {
        return "";
    }
    if (strEndIndex < 0) {
        return "";
    }
    let result = str.substring(strStartIndex, strEndIndex).substring(strStart.length);
    return result;
}

 /**
  * 没有数据情况
  * @param strObj
  */
 function dealNoData(strObj={}) {
     const rows = strObj.rows
     for(const rowIndex in rows){
         const cells = rows[rowIndex].cells
         for(const cellIndex in cells){
            const cell = cells[cellIndex]
             if(reg.test(cell.text)){
                 cell.text = ''
             }
         }
     }
     return strObj;
 }

 function getMaxIndexInRows(strObj){
     if(!strObj) return 0;
     return  Math.max(...Object.keys(strObj).filter(item=>item!='len').map(item=>Number(item)))
 }

/**
 * 组装自定义的RowObj
 * @param strObj
 * @param dataList
 * @returns {{}}
 */
 function getRowObj(strObj={},dataList={}){
     let rowObj = {};
     //保留数据集行
     let strRows = JSON.parse(JSON.stringify(strObj.rows));
     let strRowObj = {};
     //循环行
     for(let rowIndex in strRows){
         if(Number(rowIndex)<0) continue;
         strRowObj = strRows[rowIndex];
         //获取一行中的全部单元格对象
         let cellObj = strRowObj.cells;
         if(!cellObj){
             continue;
         }
         //数据集名称
         let dbName='';
         //循环一行中的所单元格
         for(let cellIndex in cellObj ){
             //单元格内容
             let cellText = cellObj[cellIndex].text || "";
             //当单元格内容是表达式时
             if(reg.test(cellText)){
                 //匹配数据集数据(返回一个匹配后的数组对象)
                 let cellTextArr = cellText.match(reg);
                 dbName = cellTextArr[1];
                 //字段名称
                 let field = cellTextArr[2];
                 //当该数据集不存在时初始化该数据集
                 if(!rowObj[dbName]){
                     rowObj[dbName] = {};
                     //记录字段的行位置
                     rowObj[dbName].rowNums = [];
                     //记录字段的列位置
                     rowObj[dbName].cellNums = [];
                     //记录字段
                     rowObj[dbName].tableFields = [];
                     //行高
                     rowObj[dbName].height = strRowObj.height;
                     //记录数据集样式(一行内的原始(解析前)数据配置)
                     rowObj[dbName].dataCells = strRows[rowIndex].cells;
                     //数据总条数
                     const total = (dataList[dbName] && dataList[dbName].length) || 0;
                     if(total>1){
                         //当数据集有多条记录时记录数据集上一行记录
                         rowObj[dbName].prevRow=strRows[(rowIndex-1<0)?0:(rowIndex-1)];
                     }else{
                         //当数据集有1条或者没有时取当前行
                         rowObj[dbName].prevRow =strRows[rowIndex];
                     }
                     //当前数据集行索引位置
                     rowObj[dbName].dataSetNumber=Number(rowIndex);
                     //是否分页
                     rowObj[dbName].isPage = dataList[`${dbName}_isPage`]
                 }
                 //保存所有字段的的行列索引
                 rowObj[dbName].rowNums.push(parseInt(rowIndex));
                 rowObj[dbName].cellNums.push(parseInt(cellIndex));
                 rowObj[dbName].tableFields.push(field);
             }else{
                 if(rowObj[dbName]){
                     rowObj[dbName].rowNums.push(parseInt(rowIndex));
                     rowObj[dbName].cellNums.push(parseInt(cellIndex));
                     rowObj[dbName].tableFields.push("");
                 }
             }

         }
     };
     //数据集高度
     if(strObj.dataSetNumber){
       strObj.dataSetHeight = strObj.rows[strObj.dataSetNumber].height;
     }
    return rowObj;
 }

/**
 * 经查询没有数据的时候需要 将表达式置为空
 */
function handleNoDataRow(strObj, rowObj) {
    let arr =[]
    Object.keys(rowObj).map(db=>{
        let tempCells = rowObj[db]['dataCells']
        if(tempCells){
            Object.keys(tempCells).map(colIndex=>{
                let cell = tempCells[colIndex]
                if(cell){
                    let exp = cell.text
                    if(exp){
                        arr.push(exp)
                    }
                }
            })
        }
    })
    const rows = strObj.rows
    for(const rowIndex in rows){
        const cells = rows[rowIndex].cells
        for(const cellIndex in cells){
            const cell = cells[cellIndex]
            if(cell && cell.text && arr.indexOf(cell.text)>=0){
                cell.text = ''
            }
        }
    }
}


 /**
  * 多条数据
  * @param strObj:表格配置
  * @param dataList:数据集合
  * @returns {*}
  * 调用方法:parseData
  */
 function dealManySource(strObj={},dataList={}){
    let rowObj = getRowObj(strObj,dataList);
    if(Object.values(rowObj) && Object.values(rowObj).length>0){
         const dataSetNumberArr = Object.values(rowObj).filter(item=>item['isPage']=='1').map(item=>item.dataSetNumber);
         if(dataSetNumberArr && dataSetNumberArr.length>0){
             //保留数据集位置，打印全部时，第二页到最后只打印列表数据
             strObj.dataSetNumber = Math.min(...dataSetNumberArr);
         }
    }
     const rowNumObj = {};
     //行数
     const initRowLen = Object.keys(strObj.rows).length;
     for(let key in rowObj){
       //遍历数据
       let tempObj = rowObj[key];
       if(!tempObj) continue;
       const dataCells = tempObj.dataCells;
       const currentCell = {};
       for (let cellIndex in dataCells){
           let cellObj = dataCells[cellIndex];
           const cellText = String(cellObj.text);
           if(!cellText) continue;
           if(cellText.startsWith('#{')){
               if(cellText.includes(key)){
                currentCell[cellIndex] = dataCells[cellIndex];
               }
           }else{
            currentCell[cellIndex] = dataCells[cellIndex];
           }
       }
       const rowNumSize = new Set(tempObj.rowNums).size;
       const cellNumSize = new Set(tempObj.cellNums).size;
       if(rowNumSize>1 && cellNumSize != 1){
          strObj.rows = {...strObj.rows,...dealOneData(strObj,{[key]:dataList[key]}).rows};
       }else{
         let currentDataRow = {};
         if (rowNumSize>1){
             //横向分组处理数据
             //取含有表达式的
             const currentCellNum = Math.min(...tempObj.cellNums);
             let strRows = JSON.parse(JSON.stringify(strObj.rows));
             const currentRow = {};
             for(let rowIndex in strRows) {
                 if (Number(rowIndex) < 0) continue;
                 let strrCells = strRows[rowIndex].cells;
                 for(let cellsIndex in strrCells) {
                     if (Number(cellsIndex) === currentCellNum){
                         currentRow[rowIndex] = strrCells[cellsIndex];
                     }
                 }
             }
             //currentCellNum 列数
             let arrmap = getRowData(tempObj.height,currentCellNum,currentRow,dataList[key]);
             currentDataRow = arrmap["rowData"];
             //处理设置单元格宽度除了第一行不起作用
             let strCol = JSON.parse(JSON.stringify(strObj.cols));
             let colSty = strCol[currentCellNum];
             for (let i = 0; i < dataList[key].length; i++) {
                 strCol[currentCellNum+i] = colSty
             }
             strObj.cols = strCol;
         }else {
             //获得当前行位置 currentRowNum 行数
             const currentRowNum = Math.min(...tempObj.rowNums);
             let arrmap = getRowData(tempObj.height,currentRowNum,currentCell,dataList[key]);
             currentDataRow = arrmap["rowData"];
             let  huamergesArr = arrmap["mergesArr"];
             strObj.merges.push.apply(strObj.merges,huamergesArr);
         }
       const newDataLen = Object.keys({...strObj.rows,...currentDataRow}).length;
         if(!currentDataRow || JSON.stringify(currentDataRow) == "{}"){
            //找到表达式对应的单元格  改成空
             handleNoDataRow(strObj, rowObj)
             continue;
         }
           let tempRepeatRange = getRepeatRange(currentDataRow)
           if(!strObj.repeatRange){
               strObj.repeatRange = []
           }
           strObj.repeatRange.push(tempRepeatRange)
           //取出新数据的位置
           const dataKeys = Object.keys(currentDataRow);
           const dataStartIndex = Math.min(...dataKeys);
           const dataEndIndex =  Math.max(...dataKeys);

       if(newDataLen<=initRowLen && cellNumSize != 1){
           //没有新数据生成
           //strObj.rows = {...strObj.rows,...currentDataRow};
           //update-begin-author:taoyan date:20201016 for:全体数据平移
           let rowCycleTrans = new RowCycleTrans(strObj, dataStartIndex, dataEndIndex, tempObj['cellNums'], currentDataRow);
           rowCycleTrans.getTransRows();
           //update-end-author:taoyan date:20201016 for:全体数据平移
           rowObj = getRowObj(strObj,dataList);
       }else{
           let rightFlag = false;
           tempObj.tableFields.forEach(item=>{
               if (item.indexOf("groupRight") != -1){
                   rightFlag = true;
               }
           })
           if (cellNumSize === 1 && rightFlag){
               //横向分组提取数据
               for(let rowIndex in currentDataRow) {
                   for(let cellIndex in currentDataRow[rowIndex].cells) {
                       strObj.rows[rowIndex].cells[cellIndex] = currentDataRow[rowIndex].cells[cellIndex];
                   }
               }
               rowObj = getRowObj(strObj,dataList);
           }else {
               //数据有新增
               maxRowNum =  (
                   Object.keys({...strObj.rows,...currentDataRow})
                       .filter(item=>item!='len')
               ).length;
               let rowsKeys = Object.keys( strObj.rows);
               let rowInterval=0;
               for (let i =0 ; i <rowsKeys.length;i++ ){
                   if(rowsKeys[i+1]-rowsKeys[i]>1){
                       rowInterval = rowsKeys[i+1]-rowsKeys[i]-1
                       break;
                   };
               };
               //取出数据剩余的部分
               const rowDataOthers  = {};
               for(let rowIndex in strObj.rows){
                   //update-begin-author:taoyan date:20201202 for:行索引可能为其他特殊字符 此处过滤掉
                   if(rowIndex=='len' || !parseInt(rowIndex) || Number(rowIndex)<=dataStartIndex) continue;
                   //update-end-author:taoyan date:20201202 for:行索引可能为其他特殊字符 此处过滤掉
                   const hasText = Object.values(strObj.rows[rowIndex].cells).some(item=>item.text);
                   if(hasText){
                       rowDataOthers[rowIndex] = {...strObj.rows[rowIndex]};
                   }
               }
               //update-begin-author:taoyan date:20201016 for:全体数据平移
               let rowCycleTrans = new RowCycleTrans(strObj, dataStartIndex, dataEndIndex, tempObj['cellNums'], currentDataRow);
               rowCycleTrans.getTransRows();
               //update-end-author:taoyan date:20201016 for:全体数据平移
               let maxRowIndex = getMaxIndexInRows(strObj.rows)+1;
               //if(rowInterval>0) maxRowIndex+=rowInterval;   //最大行值加间隔行数 key - dataStartIndex
               let newOthers = {};
               for(let key in rowDataOthers){
                   newOthers[maxRowIndex++] ={...rowDataOthers[key]};
               }
              // strObj.rows = {...strObj.rows,...newOthers}
               rowObj = getRowObj(strObj,dataList);
           }

       }
       }
     }
     const minRowNum = Math.min(...Object.values(rowNumObj));
     strObj.styles.push({"border":{"bottom":["thin","#000"],
             "top":["thin","#000"],"left":["thin","#000"],"right":["thin","#000"]}});
     const borderStyleLen = strObj.styles.length-1;
     for(let key in strObj.rows){
         if(key<minRowNum) continue;
         const cells = strObj.rows[key].cells;
         if(!cells) continue;
         Object.values(cells).forEach(cell=>{
             if(!cell.style){
                 cell.style=borderStyleLen
             }
         })
     }
     return strObj;
 }

 /**
  * 获取url参数
  */
 function getRequestUrl() {
     var url = location.search;
     var theRequest = new Object();
     if (url.indexOf("?") != -1) {
         var str = url.substr(1);
         strs = str.split("&");
         for(var i = 0; i < strs.length; i++) {
             theRequest[strs[i].split("=")[0]]=decodeURI(strs[i].split("=")[1]);
         }
     }
     return theRequest;
 }

 function getPageResult(pageNo,pageSize=10){
     const requestParam = getRequestUrl();
     requestParam.pageNo = pageNo;
     requestParam.pageSize = pageSize;
    // requestParam['onlyPageData'] = '1'
     query2RequestParam(rpViewInst.queryInfo, requestParam);
     $jm.excelView(view.excelConfigId,requestParam,(result)=> {
         var str = result.jsonStr;
         if(!str){
            return;
         }
         const dealDataList  = view.dealDataList(result.dataList);
         const dataList = dealDataList.dataList;
         //获取分页参数
         const pageObj = dealDataList.pageObj;
         if(Object.keys(pageObj).length===1){
             xs.data.settings.page = pageNo;
             xs.data.settings.total = pageObj[Object.keys(pageObj)[0]];
             if(xs.data.settings.total==1){
                 //下一页和最后一页禁用
                 xs.sheet.rpbar.btn_next.btn.el.disabled=true;
                 xs.sheet.rpbar.btn_end.btn.el.disabled=true;
             }
         }
         xs.sheet.rpbar.btn_input.countSpan.el.innerHTML=xs.data.settings.total;
         view.viewReport(str,view.getExcelData(dataList),'rpchange');
     })
 }

/**
 * 改变滚动条位置
 */
function changeScrollBottom() {
   // console.log('changeScrollBottom')
    let overlayer = document.getElementsByClassName('x-spreadsheet-overlayer');
    if(overlayer && overlayer.length>0){
        var height = overlayer[0].style.height;
        var heinum = Number(height.split('px')[0]) - 40;
        document.getElementsByClassName('x-spreadsheet-scrollbar vertical')[0].style.bottom = 'calc(100% - '+heinum+'px)';
    }
}

/**
 * 获取请求地址中的参数
 */
function getRequestUrlParam() {
    var url = window.location.href;
    var index = url.indexOf("?");
    var param = {};
    if(index>0){
        var strs = url.substring(index+1);
        var array = strs.split("&");
        for(let a of array){
            var temp = a.split('=');
            param[temp[0]] = decodeURIComponent(temp[1])
        }
    }
    return param;
}

/**
 * 判断数据库的报表参数是否匹配请求地址参数
 */
function dbParamMatchUrlParam(dbList, urlParam) {
    let res = false;
    let array = Object.keys(urlParam);
    if(!array){
        return res;
    }
    for(let item of dbList){
        if(array.indexOf(item.paramName)>=0){
            res = true;
        }
    }
    return res;
}

/**
 * 字典数据处理
 * @param json
 */
function dictDataHandler(json) {
    let dictInfo = view.dictInfo
    if(!dictInfo){
        return;
    }
    if(json){
        let rows = json.rows;
        if(rows){
            //遍历行
            Object.keys(rows).map(rowIndex=>{
                let row = rows[rowIndex].cells;
                if(row){
                    //遍历列
                    Object.keys(row).map(colIndex=>{
                        //获取单元格
                        let cell = row[colIndex]
                        if(cell.isDict===1){
                            let tempText = cell.text;
                            let tempDictList = dictInfo[cell.dictCode];
                            if(tempDictList){
                                console.log('tempText',tempDictList)
                                cell.text = getDictTextByValue(tempDictList, tempText)
                            }
                        }
                    })
                }
            })
        }
    }
}

/**
 * 获取字典 文本
 * @param ls
 * @param Value
 * @returns {string|*}
 */
function getDictTextByValue(ls, value) {
    if(!ls||ls.length==0){
        return value;
    }
    let text = ''
    for(let item of ls){
        if(item.value == value){
            text = item.text;
            break;
        }
    }
    return text;
}

/**
 * 获取数据 所在范围
 * @param rows
 * @returns {{sci: string, eci: string, sri: string, eri: string}}
 */
function getRepeatRange(rows){
    //currentDataRow
    let sri,sci,eri,eci;
    let rowsIndex = Object.keys(rows)
    sri = rowsIndex[0]
    let beginCells = rows[sri].cells
    let beginColArr = Object.keys(beginCells)
    sci = beginColArr[0]

    eri = rowsIndex[rowsIndex.length-1]
    let endCells = rows[eri].cells
    let endColArr = Object.keys(endCells)
    eci = endColArr[endColArr.length-1]
    return {sri:Number(sri), sci:Number(sci), eri:Number(eri), eci:Number(eci)}
}

/**
 * 查询报表查询信息
 * @param token
 */
async function  handleReportQueryInfo(token) {
    rpViewInst.configQueryList = []
    rpViewInst.queryInfo = {}
    await $jm.getQueryInfo(configId, token, (result)=>{
        console.log('查询配置信息', result)
        let ls =result
        if(ls){
            let obj = {}
            for(let vo of ls){
                let key = vo.dbCode+'__'+vo.name
                vo['key'] = key
                obj[key] = ''
            }
            rpViewInst.queryInfo = obj
            rpViewInst.configQueryList = [...ls]
        }
    })
}

// 手动获取图表最新的数据 组装json
function handleChartData(dataMap, jsonStr) {
    let excelOptions = JSON.parse(jsonStr);
    if (!excelOptions){
        return jsonStr;
    }
    let chartList = excelOptions.chartList;
    if(chartList && chartList.length>0){
        for(let item of chartList){
            if(!item.extData || !item.extData.dbCode){
                continue;
            }else{
                let dbCode = item.extData.dbCode
                let dataList = dataMap[dbCode]?dataMap[dbCode]['list']:null;
                for (let data of dataList) {
                    for (let key in data) {
                        let lowerkey = key.toLowerCase();
                        data[lowerkey] = data[key];
                    }
                }
                let chartOption = JSON.parse(item.config);
                //图表刷新
                preRefreshChart(item,chartOption,dataList,dataMap)
                item.config = JSON.stringify(chartOption)
            }
        }
    }
    return JSON.stringify(excelOptions);
}

/***
 * 刷新数据
 */
function refreshData(item,dataMap){
    let settings=item.extData;
    let chartOption = JSON.parse(item.config);
    //sql数据集
    if (settings.dataType === 'sql') {
        $jm.qurestSql(settings.dataId, (result)=> {
            //关系图多数据集
            if(item.extData['chartType']==='graph.simple'){
                $jm.qurestSql(item.extData.dataId1, (res)=> {
                    let { source,target }= item.extData;
                    let links = res.map((item,index)=>{
                        return {'source':item[source],'target':item[target]}
                    })
                    refreshChart(rpViewInst, chartOption, item.extData,{data:result,links:links})
                    xs.updateChart(item.layer_id ,chartOption);
                })
            }else{
                //单数据集问题
                preRefreshChart(item,chartOption,result,dataMap)
                xs.updateChart(item.layer_id ,chartOption);
            }
        })
    }else if(settings.dataType === 'api'){
        //api数据集
        Object.assign(settings,{axisX: 'name', axisY: 'value', series: 'type'})
        if(settings.apiStatus == '1'){
            $jm.qurestApi(settings.dataId,function (res) {
                preRefreshChart(item,chartOption,res.data,dataMap)
                xs.updateChart(item.layer_id ,chartOption);
            })
        }
    }
}
/***
 * 图表刷新前处理
 */
function preRefreshChart(item,chartOption,dataList,dataMap){
    if(item.extData['chartType']==='graph.simple'){
        if(item.extData['dataType']==='sql'){
            $jm.qurestSql(item.extData.dataId1, (res)=> {
                let { source,target }= item.extData;
                let links = res.map((item,index)=>{
                    return {'source':item[source],'target':item[target]}
                })
                refreshChart(rpViewInst, chartOption, item.extData,{data:dataList,links:links})
            })
        }else{
            let dbCode = item.extData.dbCode
            refreshChart(rpViewInst, chartOption, item.extData,{data:dataList,links:dataMap[dbCode]?dataMap[dbCode]['linkList']:null})
        }
    }else{
      if(item.extData.dataType!="api" && item.extData.apiStatus!='0'){
        refreshChart(rpViewInst, chartOption, item.extData, dataList)
      }
      if(item.extData.dataType=="api" && item.extData.apiStatus=='1'){
        refreshChart(rpViewInst, chartOption, item.extData, dataList)
      }
    }
}
/**
 * 将查询条件放到requestParam
 * @param queryInfo
 * @param requestParam
 */
function query2RequestParam(queryInfo, requestParam) {
    Object.keys(queryInfo).map(key=>{
        if(queryInfo[key] && !key.startsWith('jdate__')){
            requestParam[key] = queryInfo[key]
        }
    })
    requestParam['X-Access-Token'] = view.token
}

/**
 * 处理数据更新图表
 * @param list
 */
function refreshChart(vm, chartOptions, dataSettings, dataList){
    let seriesConfig = chartOptions['series']
    let chartType = dataSettings['chartType']
    if(!chartType){
        vm.$Message.warning('老数据不兼容，请删除该图表重新添加即可!');
    }
    if( chartType === 'bar.simple' || (chartType.indexOf('line.') !== -1 && chartType!=='line.multi')){
        let { axisX, axisY } = dataSettings
        let xarray = []
        let yarray = []
        for(let item of dataList){
            xarray.push(item[axisX])
            yarray.push(item[axisY])
        }
        chartOptions['xAxis']['data'] = xarray
        seriesConfig[0].data = yarray
    }
    if(chartType === 'scatter.simple'){
        let { axisX, axisY } = dataSettings
        let yarray = []
        for(let item of dataList){
            yarray.push([item[axisX],item[axisY]])
        }
        seriesConfig[0].data = yarray
    }
    if(chartType === 'scatter.bubble'){
        let { axisX, axisY, series } = dataSettings
        let seriesMap = {}
        for(let item of dataList){
            //获取series数据
            seriesMap[item[series]] = 1
        }
        let realSeries = []
        let legendData = Object.keys(seriesMap)
        let singleSeries = seriesConfig[0]
        for(let i=0;i<legendData.length;i++){
            let name = legendData[i]
            let seriesData = []
            let temparr = dataList.filter(item=>{
                return item[series] == name
            })
            temparr.forEach(function(e){
                seriesData.push([e[axisX],e[axisY]])
            })
            let itemstyle = getSeriesItemStyle(seriesConfig, i, name)
            let obj = Object.assign({},
                singleSeries,
                itemstyle,{
                    name: name,
                    data: seriesData,
                })
            realSeries.push(obj)
        }

        chartOptions['legend']['data'] = legendData
        chartOptions['series'] = realSeries
    }
    if(chartType.indexOf('pie')!=-1|| chartType === 'funnel.simple' ){
        let { axisX, axisY } = dataSettings
        let ls = [], xarray = []
        let i = 0;
        for(let item of dataList){
            let tempName = item[axisX]
            let itemStyle =  seriesConfig[0].data[i]['itemStyle']
            // getSeriesDataItemStyle(seriesConfig[0].data, tempName)
            ls.push({
                name: tempName,
                value: item[axisY],
                itemStyle: itemStyle
            })
            xarray.push(item[axisX])
            i++;
        }

        chartOptions['legend']['data'] = xarray
        seriesConfig[0].data = ls
    }

    if( chartType === 'pictorial.spirits'){
        let { axisX, axisY } = dataSettings
        let xarray = []
        let yarray = []
        for(let item of dataList){
            xarray.push(item[axisX])
            yarray.push(item[axisY])
        }
        chartOptions['yAxis']['data'] = xarray
        for(let item of seriesConfig){
            item['data'] = yarray
        }
    }

    if(chartType === 'gauge.simple'){
        let { axisX, axisY } = dataSettings
        let array = []
        for(let item of dataList){
            array.push({
                name: item[axisX],
                value: item[axisY],
            })
        }
        seriesConfig[0].data = array
    }


    if( chartType.indexOf('bar.multi')!==-1 || chartType === 'line.multi'|| chartType.indexOf('bar.stack') !== -1 ){
        let { axisX, axisY, series } = dataSettings
        let xarray = []
        let seriesMap = {}
        for(let item of dataList){
            let tempX = item[axisX]
            //获取x轴数据
            if(xarray.indexOf(tempX)<0){
                xarray.push(tempX)
            }
            //获取series数据
            seriesMap[item[series]] = 1
        }
        let realSeries = []
        let singleSeries = seriesConfig[0]
        let legendData = Object.keys(seriesMap)
        for(let i=0;i<legendData.length;i++){
            let name = legendData[i]
            let seriesData = []
            for(let x of xarray){
                let temparr = dataList.filter(item=>{
                    return item[axisX] == x && item[series] == name
                })
                if(temparr && temparr.length>0){
                    seriesData.push(temparr[0][axisY])
                }else{
                    seriesData.push(0)
                }
            }
            let itemstyle = getSeriesItemStyle(seriesConfig, i, name)
            let obj = Object.assign({},
                singleSeries,
                itemstyle,{
                    name: name,
                    data: seriesData
                })
            //处理堆叠情况
            if(chartType === 'bar.stack'){
                let tempStack=chartOptions['series'][0]['typeData'].filter(item=>{ return item.name===name });
                if(tempStack[0] && tempStack[0].stack){
                    obj['stack']=tempStack[0].stack
                }else{
                    obj['stack']=''
                }
            }
            realSeries.push(obj)
        }
        if(chartType==='bar.stack.horizontal'||chartType==='bar.multi.horizontal'){
            chartOptions['yAxis']['data'] = xarray
        }else{
            chartOptions['xAxis']['data'] = xarray
        }
        chartOptions['legend']['data'] = legendData
        chartOptions['series'] = realSeries
    }
    if(chartType === 'mixed.linebar'){
        let { axisX, axisY, series } = dataSettings
        let xarray = []
        let seriesMap = {}
        for(let item of dataList){
            let tempX = item[axisX]
            //获取x轴数据
            if(xarray.indexOf(tempX)<0){
                xarray.push(tempX)
            }
            //获取series数据
            seriesMap[item[series]] = 1
        }
        let realSeries = []
        let legendData = Object.keys(seriesMap)
        legendData.map(name=>{
            let seriesData = []
            for(let x of xarray){
                let temparr = dataList.filter(item=>{
                    return item[axisX] == x && item[series] == name
                })
                if(temparr && temparr.length>0){
                    seriesData.push(temparr[0][axisY])
                }else{
                    seriesData.push(0)
                }
            }
            let singleSeries=chartOptions['series'].filter(item=>{
                return  item['name'] == name
            })
            let obj = Object.assign({},
                singleSeries[0],{
                    name: name,
                    data: seriesData
                })
            realSeries.push(obj)
        })

        chartOptions['xAxis']['data'] = xarray
        chartOptions['legend']['data'] = legendData
        chartOptions['series'] = realSeries
    }
    if( chartType === 'map.scatter'){
        let { axisX, axisY } = dataSettings
        let ls = [];
        for(let item of dataList){
            let v=[];
            if(dataSettings.mapData){
                let data=dataSettings.mapData;
                let mapFeature = data.features.filter(district=> district.properties.name.indexOf(item[axisX])!=-1);
                if(mapFeature && mapFeature.length>0){
                    let coordinate=mapFeature[0].properties.center;
                    let lng=coordinate[0]?coordinate[0]:coordinate.lng;
                    let lat=coordinate[1]?coordinate[1]:coordinate.lat;
                    v=[lng,lat,item[axisY]];
                    ls.push({
                        name:item[axisX],
                        value: v
                    })
                }
            }
        }
        if(ls&&ls.length>0)
        seriesConfig[0].data = ls
    }
    //雷达图
     if( chartType === 'radar.basic'||chartType==='radar.custom'){
        handleRadarChart(dataSettings,dataList,chartOptions)
    }
    console.info("---chartOptions---",JSON.stringify(chartOptions))
    //关系图
    if( chartType === 'graph.simple'){
        let { axisX, axisY, series } = dataSettings;
        let seriesConfig = chartOptions['series']
        let data = dataList.data;
        let links = dataList.links;
        let seriesMap = {};
        let categories=[];
        for(let i=0,len=data.length;i<len;i++){
            //系列已存在
            if(seriesMap[data[i][series]]){
                data[i].category = seriesMap[data[i][series]];
                continue;
            }else{
                //获取series数据
                seriesMap[data[i][series]] = i;
                //获取categories数据
                let singleSeries=seriesConfig[0].categories.filter(item=>item.name === data[i][series]);
                let itemStyle=singleSeries&&singleSeries.length>0?singleSeries[0]['itemStyle']:{"color": ""};
                categories.push({name:data[i][series],itemStyle:itemStyle});
                //获取data.categories为坐标
                data[i].category = i;
            }
        }

        let legendData = Object.keys(seriesMap);
        seriesConfig[0].data=data.map(item=>{return { name:item[axisX],value:item[axisY],category:item.category }});
        seriesConfig[0].links=links;
        seriesConfig[0].categories=categories;
        chartOptions['legend']['data'] = legendData
        chartOptions['series'] = seriesConfig
    }
}
//处理雷达图数据
function handleRadarChart(dataSettings,dataList,chartOptions){
    let { axisX, axisY, series } = dataSettings
    let array = []   //分类数组
    let seriesMap = {}
    let seriesConfig = chartOptions['series']
    for(let item of dataList){
        let temp = item[axisX]
        //获取x轴数据
        if(array.indexOf(temp)<0){
            array.push(temp)
        }
        //获取系列
        seriesMap[item[series]] = 1
    }
    let realSeries = []
    let realData= []
    let legendData = Object.keys(seriesMap) //新的系列data
    //雷达数据
    for(let i=0;i<legendData.length;i++){
        let name = legendData[i] //系列值
        let seriesData = []
        for(let x of array){
            let temparr = dataList.filter(item=>{
                return item[axisX] == x && item[series] == name
            })
            if(temparr && temparr.length>0){
                seriesData.push(temparr[0][axisY])
            }else{
                seriesData.push(0)
            }
        }
        let singleSeries=seriesConfig[0].data.filter(item=>item.name === name);
        singleSeries=singleSeries.length>0?singleSeries[0]:{}
        let obj = Object.assign({},singleSeries,{
            name: name,
            value: seriesData
        })
        realData.push(obj)
    }

    let obj = Object.assign({},{
        type: 'radar',
        data: realData
    });
    realSeries.push(obj)
    chartOptions['legend']['data'] = legendData
    chartOptions['series'] = realSeries
}

//计算雷达图边界数据
function calcuMaxVal(val){
    let first=val.toString().substr(0,1);
    first=parseInt(first)+1;
    val=first + val.toString().substr(1);
    return parseInt(val);
}

/**
 * 获取当前Series index对应的itemstyle 适用于多柱体多折线
 * @param seriesConfig
 * @param index
 * @param name
 * @returns {{itemStyle: any}}
 */
function getSeriesItemStyle(seriesConfig, index, name) {
    let itemStyle = JSON.parse(JSON.stringify(seriesConfig[0]['itemStyle']))
    itemStyle['color'] = ''

    if(seriesConfig[index] && seriesConfig[index].name == name){
        itemStyle['color'] = seriesConfig[index]['itemStyle']['color']
    }
    return {itemStyle}
}

/**
 * 获取当前Series data中的itemstyle 适用于饼状图 漏斗图
 * @param seriesData
 * @param name
 * @returns {{color: string}}
 */
function getSeriesDataItemStyle(seriesData, name) {
    let itemStyle = {color:''}
    for(let item of seriesData){
        if(name === item.name){
            itemStyle = item['itemStyle']
            break;
        }
    }
    return itemStyle;
}

/**
 * 获取后台配置的报表配置
 */
function getReportConfigJson() {
    let str = '${reportConfig}';
    return JSON.parse(str)
}