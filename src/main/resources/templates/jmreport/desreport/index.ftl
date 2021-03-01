<#assign CACHE_VERSION = "v=1.0.19">
<#assign base = springMacroRequestContext.getContextUrl("")>
<#assign customPrePath = Request["customPrePath"]>
<#assign config_id = "${id!''}">
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width">
    <title>积木报表设计器</title>

    <script>
        let base = "${base}";
        let baseFull = "${base}"+"${customPrePath}";
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

        let token = getRequestUrl().token;
        if (token == "" || token == null){
            token = window.localStorage.getItem('JmReport-Access-Token');
        }
        window.localStorage.setItem('JmReport-Access-Token',token);
    </script>
    <!--引入公共资源-->
    <#include "./common/resource.ftl">
    <link rel="stylesheet" href="${base}${customPrePath}/jmreport/desreport_/corelib/report.css">
    <link rel="stylesheet" href="${base}${customPrePath}/jmreport/desreport_/corelib/jmsheet.css?${CACHE_VERSION}">
    <link rel="shortcut icon" href="${base}${customPrePath}/jmreport/desreport_/corelib/logo.png?${CACHE_VERSION}" type="image/x-ico">
    <script src="${base}${customPrePath}/jmreport/desreport_/corelib/jmsheet.js?${CACHE_VERSION}"></script>
    <script src="${base}${customPrePath}/jmreport/desreport_/corelib/locale/zh-cn.js?${CACHE_VERSION}"></script>
    <script src="${base}${customPrePath}/jmreport/desreport_/jquery/jquery-3.4.1.min.js"></script>
    <script src="${base}${customPrePath}/jmreport/desreport_/cdn/html2canvas/html2canvas.min.js"></script>
    <script src="${base}${customPrePath}/jmreport/desreport_/cdn/html2canvas/canvas2image.js"></script>
    <script src="${base}${customPrePath}/jmreport/desreport_/js/config/chart_type_list.js?${CACHE_VERSION}"></script>
    <script src="${base}${customPrePath}/jmreport/desreport_/js/config/map_type_list.js?${CACHE_VERSION}"></script>
    <!--引入自定义组件-->
    <#include "./template/index.ftl">
    <style>
        .ivu-form-item {
            margin-bottom: 10px;
            vertical-align: top;
            zoom: 1;
        }
        .ivu-menu-vertical.ivu-menu-light:after {
            content: '';
            display: block;
            width: 1px;
            height: 100%;
            background: #ffffff;
            position: absolute;
            top: 0;
            bottom: 0;
            right: 0;
            z-index: 1;
        }
        .vertical-center-modal{
            width: 60%;
            height: 60%;
            margin-left: 18%;
            margin-top: 5%;
        }
        .ivu-select-dropdown.ivu-transfer-no-max-height {
            max-height: none;
            margin-left: 142px;
        }

        .ivurow{
            position: relative;
            margin-left: 0;
            margin-right: 0;
            margin-bottom: 5px;
            height: auto;
            zoom: 1;
            display: -webkit-inline-box;
        }
        .ivu-col > div.chart-active{
            border-color: blue;
            box-shadow: 0px 0px 8px blue;
        }
        .ivu-col > div.chart-selected{
            border-color: blue !important;
            box-shadow: 0px 0px 8px blue;
        }

        .chart-modal-content .ivu-tabs-tabpane{
            padding: 0 0 0 8px;
        }
        #dataTree{
            margin-left: 25px;
        }
        .no-allowed{
            cursor: not-allowed;
           /* pointer-events: none;*/
        }

        .no-allowed:after {
            position: absolute;
            width: 200px;
            height: 150px;
            top: 0;
            left: 0;
            content: "";
            background: #fff;
            opacity: 0.65;
            z-index: 5;
            filter: alpha(opacity=40);
        }
        .colorPicker{
            width: 200%;

        }
        .colorPicker .ivu-color-picker-input{
            width: 20px;
            height: 20px;
        }
        .colorPicker .ivu-color-picker-color{
            margin-left: -5px;
            margin-top: -2px;
        }
        .iSelect{
            width: 150%;
        }
        .datastyle{
            margin-bottom: 10px;
        }
        .blockDiv{
            margin-left: 25px;margin-top: -10px;font-size: 12px;color: #000;
        }

        .jm-rp-left-container{
            position: absolute;
            top: 0;
            left: 0;
        }
        .jm-rp-right-container{
            position: absolute;
            top: 0;
            right: 0;
        }
        .jm-rp-designer{
            position: absolute;
            left: 220px;
            width: calc(100% - 470px)
        }
        .jm-rp-designer.left{
            left: 20px;
            width: calc(100% - 260px)
        }
        .jm-rp-designer.right{
            left: 220px;
            width: calc(100% - 240px)
        }
        .jm-rp-designer.all{
            left: 20px;
            width: calc(100% - 40px)
        }
        [v-cloak] {
            display: none;
        }
        .ivu-poptip-popper {
            min-width: 100px;
        }
        .ivu-poptip-body-content-word-wrap {
            text-align: center;
        }

        /*加载效果*/
        .zindex-top{
            z-index: 999;
        }
        .zindex-top .ivu-icon-ios-loading{
            animation: cycle-spin 1s linear infinite;
        }
        @keyframes cycle-spin {
            from { transform: rotate(0deg);}
            50%  { transform: rotate(180deg);}
            to   { transform: rotate(360deg);}
        }
        .ivurow>p{
            padding-top: 3px;
        }
        .dataSource .ivu-table:before{
           background-color:  #ffffff !important;
        }
        .match_setting .ivu-table:before{
           background-color:  #ffffff !important; 
        }
        .pictorial-icon-upload{
            width: 36px;
            height:36px;
            line-height: 36px;
            position: relative;
        }
        .pictorial-icon-upload>.cover{
            display: none;
            position: absolute;
            top: 0;
            bottom: 0;
            width: 67px;
            height: 50px;
            left: 0;
            right: 0;
            border-radius:3px;
            text-align: center;
            background: rgba(0,0,0,.6);
        }
        .pictorial-icon-upload:hover .cover{
            padding-top: 10px;
            display: block;
        }
        .cover i{
            color: #fff;
            font-size: 20px;
            cursor: pointer;
        }
        .ivu-tooltip-inner {
            font-size: 10px;
            padding: 2px 8px;
            min-height: 24px;
        }
        .ivu-menu-opened>.ivu-menu-submenu-title{
            color:#2d8cf0;
        }
        .ivu-tree-title-selected{
            background: none;
        }
        #dataTree .ivu-tree-title{
            padding:0;
        }

        /*样式调整 输入框小一点 -begin*/
        .little-input .ivu-input{
            padding: 3px 7px;
            height: 28px;
            border-radius: 3px;
        }
        .little-input .ivu-select-selection,
        .little-input .ivu-select-placeholder,
        .little-input .ivu-select-selected-value{
            height: 28px !important;
            line-height: 28px !important;
        }

        .little-input .ivu-input-prefix i,
        .little-input .ivu-input-suffix i{
            line-height: 28px !important;
        }
        /*样式调整 输入框小一点 -begin*/

        .excel-backgroud-st>.ivu-upload{
            display: block !important;
        }

        /*删除弹窗样式 -begin*/
        .modal-body-del {
            padding: 15px 0 0 15px;
            font-size: 18px;
            font-weight:400;
            border-top: 1px solid #e8e8e8;
            /*border-bottom: 1px solid #e8e8e8;*/
        }
        /*删除弹窗样式-end*/
        
        /*自定义表达式样式 -begin*/
        .expression .fontColor{
            color:#888;
            font-size: 14px;
        }
        .expression .ivu-input{
            resize: none;
        }  
        .expression .ivu-modal-body{
            background: rgb(248,248,248);
        }  
        .expression .expressionInput textarea{
            height: 100px;
        }
        .expression .functionDiv{
            height: 200px;
            border: 1px solid #dcdee2;
            background: #ffffff;
        }
        .expression .leftFunction{
            cursor: pointer;
        }
        .expression .leftFunctionSelect{
            cursor: pointer;
            background: #dcdee2;
        }
        .expression .functionDiv span{
            margin-left: 10px;
        }     
        .expression .childrenDiv{
            height: 200px;
            border: 1px solid #dcdee2;
            background: #ffffff;
            overflow-y: auto;
            margin-left: 10px;
        }
        .expression .childrenDiv span{
            margin-left: 10px;
        }
        .expression .activeItem{
            cursor: pointer;
        }
        .expression .rightFunctionSelect{
            cursor: pointer;
            background: #dcdee2;
        }
        .ivu-btn-primary button{
            color: white !important;
        }
        .expression .ivu-input:focus{
            border-color: #dcdee2 !important;
            -webkit-box-shadow:none !important;
            box-shadow: none !important;
        }
        .expression .ivu-input:hover{
            border-color: #dcdee2 !important;
        }
        .interpretation{
            margin-left: 10px;
        }
        .interpretation p{
            font-size: 12px;
            color:#888;
        }
        /*自定义表达式样式 -end*/

        /*去掉 excel div块的间距 使其贴住浏览器边线*/
        #tableDiv .ivu-card-body{padding: 0}
        #tableDiv .layout-content{margin: 0}
        .jm-noScroll{ overflow: hidden; }
        #propsDiv .ivu-card-body{padding-right: 5px}
    </style>
<body onload="load()" class="jm-noScroll">
<div id="app" v-cloak>
    <Spin size="large" fix v-if="createLoading" class="zindex-top">
        <Icon type="ios-loading" size=24></Icon>
        <div>Loading</div>
    </Spin>
<#include "./modal.ftl">
    <div class="layout">
        <div class="jm-rp-left-container">
            <div id="treeDiv">
                <span slot="title" @click="toggleLeft">
                    <Icon type="ios-arrow-back" size="24"/>
                </span>
                <!-- 数据源设置 -->
                <j-data-source-setting  ref="dataSource" @saveback="saveDbBack" @cancelback="cancelback"></j-data-source-setting>
                <Card style="width: 230px" v-if="dataShow">
                    <template>
                        <div id="dataDiv" :style="{'overflowY':'auto', 'height':windowHeight+'px'}">
                            <template>
                                <i-menu theme="light" width="100%" style="margin-left: -25px;" :class="menuitemClasses">
                                    <Card style="width:95%;height: 45px;border: none;margin-left: 10px; z-index:999">
                                        <div >
                                            数据集管理
                                            <Dropdown @on-click="onMenuSelect" placement="bottom-start" :transfer="true">
                                                <a href="javascript:void(0)" style="margin-left: 45px">
                                                    <Icon type="md-add" />
                                                </a>
                                                <Dropdown-menu slot="list">
                                                    <Dropdown-item name="sqlInfo">SQL数据集</Dropdown-item>
                                                    <Dropdown-item name="apiInfo">API数据集</Dropdown-item>
                                                    <Dropdown-item name="3">JavaBean数据集</Dropdown-item>
                                                </Dropdown-menu>
                                            </Dropdown>
                                        </div>
                                    </Card>
                                    <div id="dataTree">
                                        <template v-for="(item,index) in treeData">
                                            <Tree :data="item" @on-toggle-expand="onTreeToggleExpand" @on-select-change="changeTree"></Tree>
                                        </template>
                                    </div>
                                    <#--<Submenu name="param">
                                        <template slot="title">
                                            参数管理
                                        </template>
                                        <Menu-Item>
                                            <span>参数管理</span>
                                        </Menu-Item>
                                    </Submenu>
                                    <Submenu name="system">
                                        <template slot="title">
                                            系统变量
                                        </template>
                                        <Menu-Item>
                                            <span>系统变量</span>
                                        </Menu-Item>
                                    </Submenu>-->
                                    <Submenu name="reportIfo">
                                        <template slot="title">
                                            报表信息
                                        </template>
                                        <Card style="height: 160px;line-height: 8px;margin-left: 25px;">
                                            <div style="margin-left: -30%;">
                                                <i-form :model="designerObj" label-colon :label-width="90">
<#--                                                    <form-item label="编码">-->
<#--                                                        <i-input v-model="designerObj.code" disabled ></i-input>-->
<#--                                                    </form-item>-->

                                                    <form-item label="名称">
                                                        <i-input v-model="designerObj.name" placeholder="请输入名称" @on-blur="excelQueryName" @on-change="changeName"></i-input>
                                                    </form-item>

                                                    <form-item label="类型">
                                                        <i-select :model.sync="designerObj.type" v-model="designerObj.type" style="width:100%" @on-change="selectmenuList">
                                                            <i-option v-for="item in menuList" :value="item.value">{{ item.label }}</i-option>
                                                        </i-select>
                                                    </form-item>
                                                </i-form>
                                            </div>
                                        </Card>
                                    </Submenu>
                                    <j-data-dictionary ref="dataDictionary"></j-data-dictionary>
                                    <div style="width:100%;height: 45px;border: none;margin-left: 25px;cursor: pointer;margin-top: 10px" @click="createDictClick">
                                        <span>维护数据字典</span>
                                    </div>
                                </i-menu>
                            </template>
                        </div>
                    </template>
                </Card>
            </div>
        </div>

        <div :class="centerDivClass">
            <div id="tableDiv">
                <Card>
                    <div class="layout-content" style="overflow: auto">
                        <div id="jm-sheet-wrapper" style="overflow:auto"></div>
                    </div>
                </Card>
            </div>
        </div>
        <div class="jm-rp-right-container">
            <div id="propsDiv">
                <span slot="title" @click="toggleRight">
                    <Icon size="24" type="ios-arrow-forward"/>
                </span>
                <Card style="width: 235px;height: 977px" v-if="propsContentShow">
                    <Tabs size="small" v-model="rightTabName" >

                        <!-- 基本设置  -->
                        <tab-pane label="基本" name="name1" :class="'little-input'" :disabled="tabPaneDisabled">
                            <div id="propsContentDiv" class="layout-content jm-setting-container" :style="{height: settingsHeight+'px'}">
                                <div>
                                    <p>坐标</p>
                                    <i-input disabled v-model="excel.coordinate"></i-input>
                                    <p>类型</p>
<#--                                    <p @click="customExpression">自定义表单式</p>-->
                                    <i-select v-model="excel.type" @on-change="onChangeCellDisplay">
                                        <i-option value="normal" key="1">文本</i-option>
                                        <i-option value="img" key="2">图片</i-option>
                                        <i-option value="barcode" key="3">条形码</i-option>
                                        <i-option value="qrcode" key="4">二维码</i-option>
                                        <#--<i-option value="chart" key="5">图表</i-option>-->
                                    </i-select>
                                    <p>值</p>
                                    <div>
                                        <i-input v-model="excel.excelValue" @keyup.enter.native="submitValue"></i-input>
                                    </div>

                                    <div v-if="excel.hasGroup">
                                        <p>聚合方式</p>
                                        <i-select ref="excelPolyWay" :model.sync="excel.polyWay" v-model="excel.polyWay" @on-change="selectPolyList">
                                            <i-option v-for="item in polyWayList" :value="item.value">{{ item.label }}</i-option>
                                        </i-select>
                                        <p>扩展方向</p>
                                        <i-select :model.sync="excel.direction" v-model="excel.direction" @on-change="selectDirectionList">
                                            <i-option v-for="item in directionList" :value="item.value">{{ item.label }}</i-option>
                                        </i-select>

                                        <p>高级配置</p>
                                        <i-select :model.sync="excel.advanced" v-model="excel.advanced" @on-change="selectAdvancedList">
                                            <i-option v-for="item in advancedList" :value="item.value">{{ item.label }}</i-option>
                                        </i-select>

                                    </div>

                                   <#-- <p>显示</p>
                                    <div>
                                        <i-input></i-input>
                                    </div>

                                    <p>行依赖</p>
                                    <i-select>
                                        <i-option value="default" key="1">默认</i-option>
                                        <i-option value="customer" key="2">自定义</i-option>
                                    </i-select>
                                    <p>列依赖</p>
                                    <i-select>
                                        <i-option value="default" key="1">默认</i-option>
                                        <i-option value="customer" key="2">自定义</i-option>
                                    </i-select>-->

                                    <p>超链接</p>
                                    <div>
                                        <i-input></i-input>
                                        <Icon type="md-create"/>
                                    </div>

                                    <p>弹出目标</p>
                                    <i-select>
                                        <i-option value="1" key="1">当前窗口</i-option>
                                        <i-option value="2" key="2">新窗口</i-option>
                                        <i-option value="3" key="3">父窗口</i-option>
                                        <i-option value="4" key="4">顶层窗口</i-option>
                                        <i-option value="5" key="5">自定义</i-option>
                                    </i-select>

                                    <p>自定义属性</p>
                                    <div>
                                        <i-input></i-input>
                                    </div>

<#--                                    <p>是否是字典</p>-->
<#--                                    <i-select @on-change="selectUseDict" v-model="excel.isDict">-->
<#--                                        <i-option :value="0" key="1">否</i-option>-->
<#--                                        <i-option :value="1" key="2">是</i-option>-->
<#--                                    </i-select>-->

<#--                                    <div v-if="excel.isDict=='1'">-->
<#--                                        <p>字典编码</p>-->
<#--                                        <div>-->
<#--                                            <i-input @on-blur="changeDictCode" v-model="excel.dictCode" placeholder="请输入"></i-input>-->
<#--                                        </div>-->
<#--                                    </div>-->

                                    <p v-if="chartsflag">偏移量</p>
                                    <div v-if="chartsflag">
                                        <i-input v-model="offsetInfo" @on-blur="changeLayerOffset"></i-input>
                                    </div>

                                    <p>小数位数</p>
                                    <div>
                                        <i-input v-model="excel.decimalPlaces" @on-blur="onChangeDecimalPlaces"></i-input>
                                    </div>
                                </div>
                            </div>
                        </tab-pane>

                        <!-- 图表样式设置  -->
                        <tab-pane v-if="chartsflag && !backgroundSettingShow" label="样式" name="name2" :disabled="selectedChartType==='apiUrlType'">
                            <i-menu theme="light" width="auto" :style="{height: settingsHeight+'px', marginLeft: '-20px'}" :class="menuitemClasses" accordion>

                                <!-- 标题设置 -->
                                <j-title-setting v-if="titleSettings" @change="onSettingsChange" :settings="titleSettings"></j-title-setting>
                                <!-- 柱体设置 -->
                                <j-bar-setting v-if="barSettings" @change="onSeriesChange" :settings="barSettings" :is-multi-chart="isMultiChart"></j-bar-setting>
                                <!-- 线体设置 -->
                                <j-line-setting v-if="lineSettings" @change="onSeriesChange" :settings="lineSettings" :is-multi-chart="isMultiChart"></j-line-setting>
                                <!-- 饼图设置-->
                                <j-pie-setting v-if="pieSettings" @change="onSeriesChange" :settings="pieSettings"></j-pie-setting>
                                <!-- 边距设置-->
                                <j-margin-setting v-if="marginSettings" @change="onSeriesChange" :settings="marginSettings"></j-margin-setting>
                                <!-- 中心点设置-->
                                <j-central-point-setting v-if="centralPointSettings" @change="onSeriesChange" :settings="centralPointSettings"></j-central-point-setting>
                                <!-- 漏斗设置-->
                                <j-funnel-setting v-if="funnelSettings" @change="onSeriesChange" :settings="funnelSettings"></j-funnel-setting>
                                <!-- 象形图设置 -->
                                <j-pictorial-setting v-if="pictorialSettings" @change="onPictorialChange" @upload-success="pictorialIconUploadSuccess" :settings="pictorialSettings"></j-pictorial-setting>
                                <!-- 地图设置 -->
                                <j-map-setting  ref="mapModal" v-if="mapGeoSettings" @change="onSettingsChange" :settings="mapGeoSettings"></j-map-setting>
                                <!-- 散点设置-->
                                <j-scatter-setting v-if="scatterSettings" @change="onSeriesChange" :settings="scatterSettings"></j-scatter-setting>
                                <!-- 雷达设置-->
                                <j-radar-setting v-if="radarSettings" @change="onSettingsChange" :settings="radarSettings"></j-radar-setting>
                                <!-- 仪表盘设置-->
                                <j-gauge-setting v-if="gaugeSettings" @change="onSeriesChange" :settings="gaugeSettings"></j-gauge-setting>
                                <!-- x轴设置-->
                                <j-xaxis-setting v-if="xAxisSettings" @change="onSettingsChange" :settings="xAxisSettings"></j-xaxis-setting>
                                <!-- y轴设置(settings支持数组)-->
                                <j-yaxis-setting v-if="yAxisSettings" @change="onSettingsChange" :settings="yAxisSettings"></j-yaxis-setting>
                                <!-- 数值设置-->
                                <j-series-setting v-if="seriesLabelSettings" @change="onSeriesChange" :settings="seriesLabelSettings"></j-series-setting>
                                <!-- 提示语设置-->
                                <j-tooltip-setting v-if="tooltipSettings" @change="onSettingsChange" :settings="tooltipSettings"></j-tooltip-setting>
                                <!-- 坐标轴边距设置-->
                                <j-grid-setting v-if="gridSettings" @change="onSettingsChange" :settings="gridSettings"></j-grid-setting>
                                <!-- 图例设置-->
                                <j-legend-setting v-if="legendSettings" @change="onSettingsChange" :settings="legendSettings"></j-legend-setting>
                                <!-- 自定义配色-->
                                <j-match-setting style="border-bottom: inset 1px;" v-if="graphSettings ||gaugeSettings ||funnelSettings || pieSettings || isMultiChart || selectedChartType.indexOf('multi')!=-1 || selectedChartType == 'radar.basic'" :chart-options="chartOptions"  :data-settings="dataSettings" ></j-match-setting>
                                <!-- 背景设置-->
                                <j-background-setting  @change="chartBackgroundChange" @upload-success="chartBackgroundUploadSuccess" @remove="removeChartBackground" :settings="chartBackground"></j-background-setting>
                            </i-menu>
                        </tab-pane>

                        <!-- 图表数据设置  -->
                        <tab-pane v-if="chartsflag && selectedChartType !== 'map.simple'" label="数据" name="name3" :class="'little-input'">
                            <div class="datastyle">
                                <p>数据类型:</p>
                                <i-select v-model="dataSettings.dataType" :disabled="selectedChartType==='apiUrlType'" @on-change="dataTypeChange">
                                    <i-option value="sql">SQL数据集</i-option>
                                    <i-option value="api">Api数据集</i-option>
                                </i-select>
                            </div>

                            <!-- api数据集 -->
                            <div class="datastyle" v-if="dataSettings.dataType == 'api'">
                                <div class="datastyle">
                                    <p>Api类型:</p>
                                    <i-select v-model="dataSettings.apiStatus" :disabled="selectedChartType==='apiUrlType'" @on-change="seriesOnChange">
                                        <i-option value="0">静态数据</i-option>
                                        <i-option value="1">动态数据</i-option>
                                        <i-option value="2">接口请求</i-option>
                                    </i-select>
                                </div>
                                <div class="datastyle" v-if="dataSettings.apiStatus == '0'">
                                    <span style="display: inline-block;text-align: left;width: calc(100% - 50px);">请自定义数据值:</span>
                                    <i-button style="width: 44px;" size="small" type="primary" @click="addEchartInfoData">编辑</i-button>
                                </div>
                                <div class="datastyle" v-if="dataSettings.apiStatus == '2'">
                                    <p>接口url:&nbsp;&nbsp;</p>
                                    <i-input v-model="dataSettings.apiUrl" :autosize="true" type="textarea" placeholder="请输入接口地址..."></i-input>
                                </div>
                                <div class="datastyle" v-if="dataSettings.apiStatus == '1'">
                                    <div>
                                        <p>绑定数据集:</p>
                                        <i-select v-model="dataSettings.dataId" @on-change="onSelectApiData">
                                            <i-option v-for="item in apiDataList" :value="item.dbId">{{ item.title }}</i-option>
                                        </i-select>
                                    </div>
                                </div>
                            </div>

                            <!-- sql数据集 -->
                            <div class="datastyle" v-if="dataSettings.dataType == 'sql'">
                                <div class="datastyle">
                                    <p>绑定数据集:</p>
                                    <i-select v-model="dataSettings.dataId" @on-change="onSelectSqlData">
                                        <i-option v-for="item in sqlDataList" :value="item.dbId">{{ item.title }}</i-option>
                                    </i-select>
                                </div>
                                <div class="datastyle">
                                    <p>分类属性:</p>
                                    <i-select v-model="dataSettings.axisX" @on-change="onAxisXConfigChange">
                                        <i-option v-for="item in sqlDataFieldList" :value="item.title">{{ item.title }}</i-option>
                                    </i-select>
                                </div>
                                <div class="datastyle">
                                    <p>值属性:</p>
                                    <i-select :model.sync="dataSettings.axisY" v-model="dataSettings.axisY" @on-change="onAxisYConfigChange">
                                        <i-option v-for="item in sqlDataFieldList" :value="item.title">{{ item.title }}</i-option>
                                    </i-select>
                                </div>
                                <template v-if="isMultiChart || selectedChartType.indexOf('radar') !==-1 || selectedChartType == 'graph.simple'">
                                    <div class="datastyle">
                                        <p>系列属性:</p>
                                        <i-select v-model="dataSettings.series">
                                            <i-option v-for="item in sqlDataFieldList" :value="item.title">{{ item.title }}</i-option>
                                        </i-select>
                                    </div>
                                </template>
                                <#--分割线-->
                                <template v-if="selectedChartType == 'graph.simple'">
                                    <Divider  style="margin: 20px 0 20px 0"></Divider>
                                    <div class="datastyle">
                                        <p>绑定节点关系数据集:</p>
                                        <i-select v-model="dataSettings.dataId1" @on-change="onSelectSqlData2">
                                            <i-option v-for="item in sqlDataList" :value="item.dbId">{{ item.title }}</i-option>
                                        </i-select>
                                    </div>
                                    <div class="datastyle">
                                        <p>来源属性:</p>
                                        <i-select v-model="dataSettings.source">
                                            <i-option v-for="item in sqlDataFieldList2" :value="item.title">{{ item.title }}</i-option>
                                        </i-select>
                                    </div>
                                    <div class="datastyle">
                                        <p>目标属性:</p>
                                        <i-select :model.sync="dataSettings.target" v-model="dataSettings.target">
                                            <i-option v-for="item in sqlDataFieldList2" :value="item.title">{{ item.title }}</i-option>
                                        </i-select>
                                    </div>
                                </template>
                            </div>

                            <!-- 多维度处理  -->
                            <div class="datastyle" v-if="(dataSettings.dataType == 'sql' || dataSettings.apiStatus == '1' || dataSettings.apiStatus == '0') && (selectedChartType == 'mixed.linebar'||selectedChartType == 'bar.stack')|| selectedChartId=='bar.negative'">
                                <p>系列类型:</p>
                                <div style="margin-top: 5px;">
                                    <Row class="ivurow" style="margin-top: 5px;">
                                        <i-button type="primary" size="small" @click="seriesModal=true">新增</i-button>
                                    </Row>
                                    <i-table stripe :columns="seriesColumns" :data="seriesTypeData"></i-table>
                                </div>
                            </div>
                        <#--刷新配置-->
                            <template v-if="dataSettings.apiStatus==='1' || dataSettings.dataType == 'sql'">
                                <div class="datastyle">
                                    <span style="display: inline-block;text-align: left;width: calc(100% - 50px);">定时刷新:</span>
                                    <i-switch size="small" v-model="dataSettings.isTiming" @on-change="timerChange"/>
                                </div>
                                <div class="datastyle" style="display: flex;align-items: center;" v-if="dataSettings.isTiming">
                                    <span style="display: inline-block;text-align: left;width: calc(100% - 100px);">刷新间隔:</span>
                                    <i-input size="small" type="number" v-model="dataSettings.intervalTime" style="width:100px" @on-blur="timerChange"><span slot="append">秒</span></i-input>
                                </div>
                            </template>
                            <i-button @click="runChart" type="primary" style="width: 100%;height: 36px;margin-top: 10%;">运行</i-button>
                        </tab-pane>

                        <!-- 背景图设置  -->
                        <tab-pane v-if="backgroundSettingShow" style="visibility: visible" label="背景图设置" name="name4" :class="'little-input'">
                           <div :class="backgroundSettings.path?'excel-backgroud-st':''" style="height: 500px;overflow-y: auto">
                               <span style="display:inline-block;margin: 5px 0">图片：</span>
                               <Upload
                                   ref="upload"
                                   :show-upload-list="false"
                                   :default-file-list="backgroundImg"
                                   :on-success="backgroundImgUploadSuccess"
                                   :on-exceeded-size="(e)=>handleMaxSize(e,10)"
                                   :format="['jpg','jpeg','png']"
                                   :max-size="10240"
                                   :action=" actionUrlPre + '/jmreport/upload' "
                                   style="display: inline-block;width:58px;">
                                   <div style="display: block" class="pictorial-icon-upload" v-if="backgroundSettings.path">
                                       <img style="width: 196px;max-height: 100px" :src="getBackgroundImg()"/>
                                       <div class="cover" style="width: 196px">
                                           <Icon type="ios-create-outline"/>
                                       </div>
                                   </div>
                                   <i-button v-else style="margin-left:25px" type="primary" size="small">上传</i-button>
                               </Upload>

                               <div style="width:100%">
                                   <p style="padding: 6px 0">图片宽度:</p>
                                   <i-input v-model="backgroundSettings.width" @on-blur="backgroundChange"></i-input>

                                   <p style="padding: 6px 0">图片高度:</p>
                                   <i-input v-model="backgroundSettings.height" @on-blur="backgroundChange"></i-input>
                               </div>

                               <div style="width:100%;">
                                   <p style="padding: 6px 0">重复设置:</p>
                                   <i-select v-model="backgroundSettings.repeat" style="width:99%" @on-change="backgroundChange">
                                       <i-option value="repeat">默认</i-option>
                                       <i-option value="repeat-x">水平重复</i-option>
                                       <i-option value="repeat-y">垂直重复</i-option>
                                       <i-option value="no-repeat">无重复</i-option>
                                   </i-select>
                               </div>

                               <i-button v-if="backgroundSettings.path" style="width: 99%;margin:10px 0" type="primary" @click="removeBackground">取消背景图</i-button>
                           </div>
                        </tab-pane>

                        <!-- 条形码设置  -->
                        <tab-pane v-if="barcodeSettings" style="visibility: visible" label="条形码设置" name="name5" :class="'little-input'">
                            <j-barcode-setting @change="onBarcodeChange" :settings="barcodeSettings"></j-barcode-setting>
                        </tab-pane>

                        <!-- 二维码设置  -->
                        <tab-pane v-if="qrcodeSettings" style="visibility: visible" label="二维码设置" name="name6" :class="'little-input'">
                            <j-qrcode-setting @change="onBarcodeChange" :settings="qrcodeSettings"></j-qrcode-setting>
                        </tab-pane>
                    </Tabs>

                </Card>
            </div>
        </div>
    </div>
</div>

<script>

    var excel_config_id = "${config_id}";
    var excel_req_token = '';
    var xs = null;
    var vm = null;

    /**
     * 获取后台配置的报表配置
     */
    function getReportConfigJson() {
        let str = '${reportConfig}';
        return JSON.parse(str)
    }

    function load() {
        let token = window.localStorage.getItem('JmReport-Access-Token');
        if (token == "" || token == null){
            token = getRequestUrl().token;
        }
        excel_req_token = token
        console.log("index_load--------------",token);
        let reportConfig = getReportConfigJson();
        let colLength = 50, viewPageSize = [10,20,30], printPaper = []
        if(reportConfig['pageSize']){
            viewPageSize = reportConfig['pageSize']
        }
        if(reportConfig['col']){
            colLength = reportConfig['col']
        }
        if(reportConfig['printPaper']){
            printPaper = reportConfig['printPaper']
        }
        const options = {
            "domain": 'http://localhost:8080/jeecg-boot',
            "viewLocalImage":"/jmreport/img",//预览本地图片方法
            "uploadUrl":"/jmreport/upload", //统一上传地址
            "uploadExcelUrl":"/jmreport/importExcel?token="+token,//上传excel方法
            pageSize: viewPageSize, //分页条数
            printPaper: printPaper,
            domain:window.location.origin+base,
            showToolbar: true,     //头部操作按钮
            showGrid: true,        //excel表格
            showContextmenu: true, //右键操作按钮
            view: {
                height: () => document.documentElement.clientHeight,
                width: () => document.documentElement.clientWidth,
            },
            row: {
                len: 100,
                height: 25,
                minRowResizerHeight:1 //拖拽行最小高度
            },
            col: {
                len: colLength,
                width: 100,
                minWidth: 60,
                height: 0,
                minColResizerHeight:1//拖拽列最小高度
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
                    name: 'Microsoft YaHei',
                    size: 10,
                    bold: false,
                    italic: false,
                },
            },
        };

        x.spreadsheet.locale('zh-cn');
        xs = x.spreadsheet('#jm-sheet-wrapper', options)
                .onSave(function (data) {
                    //设置报表打印宽度
                    const dataRect = xs.data.getDataRect();
                    let dataRectWidth = 0;
                    if(dataRect){
                        dataRectWidth = dataRect.w;
                    }
                    //直接读取文本框的值
                    const printElWidth = xs.sheet.toolbar.toolPrintInputEl.input.el.value
                    data['dataRectWidth'] = dataRectWidth;
                    data['excel_config_id'] = excel_config_id;
                    data['printElWidth'] = Number(printElWidth) || dataRectWidth;
                    data['printElHeight'] = Number(xs.sheet.toolbar.toolPrintHeightInputEl.input.el.value)
                    data['toolPrintSizeObj'] = xs.data.toolPrintSizeObj;

                    $jm.excelSave(data, token,function () {
                        xs.tip("保存成功!");
                    });
                })
                .onAddChart(function(a){
                    vm.addChartModule();
                })
                .onSelectChart(function(data){
                    vm.clearRightTabpane();
                    setTimeout(()=>{
                        vm.selectChart(data);
                    },200)
                })
                .onChartDelete(function(){
                    vm.chartsflag=false;
                    vm.rightTabName='name1';
                })
                .onSettingEvent(function (e, param) {
                    if(e==='background'){
                        vm.handleBackground(param)
                    }else if(e==='clickcell'){
                        vm.onClickCell(param)
                    }
                })
                // 自定义校验
                .onValidate(function (type, cell) {
                    if(type === 'editor'){
                        //此事件 cell对象只回传了这三个属性值
                        let { flag, text } = vm.validateDbExpression(cell.text)
                        xs.updateEditor({error: !flag, text: text})
                    }
                })
                .onUploadExcel(function (res) {
                   if(!res.success) return;
                   const xsData ={...xs.getData()};
                   xsData.styles = res.result.style;
                   xsData.rows = res.result.rows;
                   xs.loadData(xsData);
               })
                .onCellExpress(function (res) {
                     vm.customExpressionShow=true
                     if(res){
                       vm.expression=res 
                     }
                    vm.commonFunction=true
                    vm.newFunctionList=["SUM","DBSUM","AVERAGE","DBAVERAGE","MIN","DBMIN","MAX","DBMAX"]
                    vm.leftFunctionIndex=0
                })

        $jm.excelGet(excel_config_id,(res)=> {
            //加入预览地址
            xs.data.settings.viewUrl = window.location.origin+api.view+excel_config_id;
            var str = res.jsonStr;
            if(!str) return;
            //页面加载时设置报表宽度
            const jsonStr = JSON.parse(str);
            console.log('jsonstr', jsonStr)
            if(jsonStr.chartList)
            {
                jsonStr.chartList.forEach(function(item){
                    let config = JSON.parse(item.config);
                    if (config.geo){
                        if (loadMap){
                            loadMap && loadMap(item)
                        }
                    }
                })
            }
            xs.data.settings.printElWidth = jsonStr.printElWidth || 0;
            xs.data.printElHeight = jsonStr.printElHeight ||  1047; //默认a4纸大小
            xs.sheet.toolbar.toolPrintHeightInputEl.input.el.value =  xs.data.printElHeight;
            xs.loadData(jsonStr);
            setTimeout(function(){
                if (xs.data.chartList && xs.data.chartList.length > 0){
                    //vm.tabPaneShow();
                    vm.refreshAllChart(xs.data.chartList);
                }
            },300)
        },(res)=>{
            xs.tip(res.message);
        });
        /*xs.sheet.toolbar.toolPrintInputEl.input.el.onchange=(e=>{
            var clientWidth = document.documentElement.clientWidth;
            var remainingWidth = clientWidth - e.target.value - 330;
            if (remainingWidth<300){
                xs.sheet.horizontalScrollbar.el.el.style.overflowX="scroll";
            }else {
                xs.sheet.horizontalScrollbar.el.el.style.overflowX="hidden";
            }
        })*/
    }

</script>
<script type="text/javascript" src="${base}${customPrePath}/jmreport/desreport_/js/util.js?${CACHE_VERSION}"></script>
<script type="text/javascript" src="${base}${customPrePath}/jmreport/desreport_/js/biz/design.js?${CACHE_VERSION}"></script>
<script>
     window.onbeforeunload = function(event){
	   return '您可能有数据没有保存';
     };
</script>
</html>
