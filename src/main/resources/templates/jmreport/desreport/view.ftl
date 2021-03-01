<#assign CACHE_VERSION = "v=1.0.19">
<#assign base = springMacroRequestContext.getContextUrl("")>
<#assign customPrePath = Request["customPrePath"]>
<#assign config_id = "${id!''}">
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width">
<title></title>
<script>
    let configId= '${config_id}';
    var reportMode = "${mode!''}"
    let base = '${base}';
    let customPrePath = '${customPrePath}';
    let baseFull = "${base}"+"${customPrePath}";
    let token ="";
    if (token == "" || token == null){
        token = window.localStorage.getItem('JmReport-Access-Token');
    }
</script>
<#include "./common/resource.ftl">
<!-- Import via CDN -->
<link rel="stylesheet" href="${base}${customPrePath}/jmreport/desreport_/corelib/jmsheet.css?${CACHE_VERSION}">
<script src="${base}${customPrePath}/jmreport/desreport_/corelib/jmsheet.js?${CACHE_VERSION}"></script>
<script src="${base}${customPrePath}/jmreport/desreport_/corelib/locale/zh-cn.js?${CACHE_VERSION}"></script>
<script src="${base}${customPrePath}/jmreport/desreport_/jquery/jquery-3.4.1.min.js"></script>
<link rel="shortcut icon" href="${base}${customPrePath}/jmreport/desreport_/corelib/logo.png?${CACHE_VERSION}" type="image/x-ico">
<script>
    // $http.get({
    //     url : api.show,
    //     data:{"id":configId},
    //     success : function(result) {
    //         document.title = result.name;
    //     }
    // });
</script>
<style>
  #jm-sheet-wrapper * {
    color: #000000;
    -webkit-tap-highlight-color: #000000!important;
   }
    body{
        overflow-y:hidden !important;
    }


    /*--查询区域的样式设置 --*/
  .ty-bar-container{
      padding-left: 12px;
  }

  .jm-query-collapse .ivu-collapse-header .ivu-icon{
      font-size: 20px;
      font-weight: 700;
      margin-right: 5px !important;
  }

  .jm-query-form .ivu-input{
      padding: 3px 7px;
      height: 28px;
      border-radius: 3px;
      width: 140px;
  }

  .jm-query-form .jmreport-query-datetime .ivu-input{
      width: 160px;
  }

  .jm-query-form .ivu-select-selection{
      width: 140px;
  }

  /*--多选 --*/
  .jm-query-form .ivu-select-multiple .ivu-select-selection{
      width: 200px;
      min-height: 28px !important;
  }

  .jm-query-form .ivu-select-multiple .ivu-tag{
      height: 20px;
      line-height: 20px;
      margin: 3px 4px 3px 0;
      vertical-align: baseline;
      max-width: 62% !important;
  }
  .jm-query-form .ivu-select-multiple .ivu-tag i{
      top: 3px;
  }

  .jm-query-form  .ivu-btn{height:30px !important;}
  .jm-query-form  .ivu-btn>.ivu-icon{
      font-size:16px;
  }


  .jm-query-form .ivu-select-selection,
  .jm-query-form .ivu-select-placeholder,
  .jm-query-form .ivu-select-selected-value{
      height: 28px !important;
      line-height: 28px !important;
  }

  .jm-query-form .ivu-input-prefix i,
  .jm-query-form .ivu-input-suffix i{
      line-height: 28px !important;
  }
  /*--查询区域的样式设置 --*/

  .jm-search-btns .ivu-form-item-content{
      margin-left: 30px !important;
  }
  .jm-query-form .ivu-select-dropdown{
      z-index: 99999;
  }  
</style>
<body onload="view.load('${config_id}')" style="overflow: hidden">
<div id="app" style="overflow: hidden">
    <!-- 查询条件 -begin -->
    <div v-if="configQueryList && configQueryList.length>0">
        <Collapse class="jm-query-collapse">
            <Panel name="1">
                <span style="color: #000000;" title="点击展开显示查询信息">查 询 栏</span>
                <div slot="content">
                    <i-form ref="queryForm" :model="queryInfo" inline :label-width="100" class="jm-query-form">
                        <template v-for="(item, index) in configQueryList">
                            <form-item :label="getQueryItemLabel(item)" :index="index">
                                <template v-if="item.dictList && item.dictList.length>0">
                                    <!-- 多选 -->
                                    <i-select v-if="item.mode==3" v-model="queryInfo['jdate__'+item.key]" multiple :max-tag-count="1" @on-change="(arr)=>handleQueryMultiSelectChange(arr, item.key)" :placeholder="'请选择'+item.title">
                                        <i-option v-for="(dict, dIndex) in item.dictList" :index="index" :value="dict.value">{{ dict.text }}</i-option>
                                    </i-select>

                                    <!-- 单选 -->
                                    <i-select v-else v-model="queryInfo[item.key]" :placeholder="'请选择'+item.title">
                                        <i-option v-for="(dict, dIndex) in item.dictList" :index="index" :value="dict.value">{{ dict.text }}</i-option>
                                    </i-select>
                                </template>

                                <template v-else-if="item.type=='number'">
                                    <Row v-if="item.mode==2">
                                        <i-col span="11">
                                            <i-input v-model="queryInfo[item.key+'_begin']" type="number" :placeholder="'请输入起始值'"></i-input>
                                        </i-col>
                                        <i-col span="2" style="text-align: center">&nbsp;~</i-col>
                                        <i-col span="11">
                                            <i-input v-model="queryInfo[item.key+'_end']" type="number" :placeholder="'请输入结束值'"></i-input>
                                        </i-col>
                                    </Row>
                                    <i-input v-else type="number" v-model="queryInfo[item.key]" :placeholder="'请输入'+item.title"></i-input>
                                </template>

                                <template v-else-if="item.type=='date' || item.type=='datetime'">
                                    <Row v-if="item.mode==2" :class="'jmreport-query-'+item.type">
                                        <i-col span="11">
                                        <date-picker v-model="queryInfo['jdate__'+item.key+'_begin']" @on-change="(str)=>handleQueryDateChange(str, item.key+'_begin')" :type="item.type" :placeholder="'请选择起始值'"></date-picker>
                                        </i-col>
                                        <i-col span="2" style="text-align: center">&nbsp;~</i-col>
                                        <i-col span="11">
                                        <date-picker v-model="queryInfo['jdate__'+item.key+'_end']" @on-change="(str)=>handleQueryDateChange(str, item.key+'_end')" :type="item.type" :placeholder="'请选择结束值'"></date-picker>
                                        </i-col>
                                    </Row>
                                    <date-picker :class="'jmreport-query-'+item.type" v-else v-model="queryInfo['jdate__'+item.key]" @on-change="(str)=>handleQueryDateChange(str, item.key)" :type="item.type" :placeholder="'请选择'+item.title"></date-picker>
                                </template>

                                <i-input v-else v-model="queryInfo[item.key]" :placeholder="'请输入'+item.title"></i-input>
                            </form-item>
                        </template>

                        <form-item class="jm-search-btns">
                            <i-button type="primary" icon="ios-search-outline" @click="doReportQuery">查询</i-button>
                            <i-button style="margin-left: 8px" icon="ios-redo-outline" @click="resetReportQuery">重置</i-button>
                        </form-item>

                    </i-form>
                </div>
            </Panel>
        </Collapse>
    </div>
    <!-- 查询条件 -end -->
    <div id="jm-sheet-wrapper" style="width:100%;height: 100%"></div>

    <!-- 报表参数弹框 -->
    <Modal
        :closable="false"
        :mask-closable="false"
        :loading="loading"
        v-model="visible"
        title="请填写报表参数"
        :width="500">
        <div slot="footer">
            <i-button type="primary" @click="onSave" style="color:#fff !important;">确定</i-button>
        </div>
        <div style="padding-right: 30px">
            <i-form :model="reportParamObj" label-colon :label-width="90">
                <form-item :label="item.paramTxt" v-for="(item, index) in reportParamList">
                    <i-input style="width: 90%" :key="index" v-model="reportParamObj[item.paramName]" :placeholder="'请输入'+ item.paramTxt "></i-input>
                </form-item>
            </i-form>
        </div>
    </Modal>
</div>
<#--预览js-->
<script type="text/javascript" src="${base}${customPrePath}/jmreport/desreport_/js/util.js?${CACHE_VERSION}"></script>
<script type="text/javascript" src="${base}${customPrePath}/jmreport/desreport_/js/biz/row.express.js?${CACHE_VERSION}"></script>
<script type="text/javascript" src="${base}${customPrePath}/jmreport/desreport_/js/biz/row.cycle.js?${CACHE_VERSION}"></script>
<script type="text/javascript" src="${base}${customPrePath}/jmreport/desreport_/js/biz/view.js?${CACHE_VERSION}"></script>
</body>
</html>
