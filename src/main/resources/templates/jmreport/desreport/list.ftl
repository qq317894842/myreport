<#assign CACHE_VERSION = "v=1.0.19">
<#assign base = springMacroRequestContext.getContextUrl("")>
<#assign customPrePath = Request["customPrePath"]>
<!DOCTYPE html>
<html>
<head>
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
<meta charset="utf-8">
<meta name="viewport" content="width=device-width">
<title>报表在线设计</title>
    <#include "./common/resource.ftl">
    <link rel="stylesheet" href="${base}${customPrePath}/jmreport/desreport_/corelib/cust.css?${CACHE_VERSION}">
    <link rel="shortcut icon" href="${base}${customPrePath}/jmreport/desreport_/corelib/logo.png?${CACHE_VERSION}" type="image/x-ico">
</head>
<body style="background: #000">
<style>

    .ivu-page,
    .ivu-page-prev,
    .ivu-page-next,
    .ivu-select-selection,
    .ivu-select-dropdown,
    .ivu-page.mini .ivu-page-options-elevator input
    {
        background-color: black;
        color: #fff;
    }
    .page{
        display: flex;
        justify-content: center;
        -webkit-box-pack: center;
    }
    .ivu-page-item{
        background-color: black;
        border: 1px solid #000000;
    }
    .ivu-page-item-active{
        background-color: black;
        border: 1px solid #409eff;
    }
    .ivu-page-item a{
        margin: 0 6px;
        text-decoration: none;
        color: #fff;
    }
    .ivu-page-next a, .ivu-page-prev a {
        font-size: 14px;
        color: #fff;
    }
    .ivu-spin-fix{
        background-color: rgba(131, 125, 125, 0.5);
    }
</style>
<style>
    .title{
        font-size: 20px;
        color: #fff;
        text-align: center;
        line-height: 60px;
        font-weight: 500;
    }
    .ivu-layout-sider {
        transition: all .2s ease-in-out;
        position: relative;
        background: #000000;
    }
    .ivu-layout {
        display: flex;
        -webkit-box-orient: vertical;
        -webkit-box-direction: normal;
        flex-direction: column;
        -webkit-box-flex: 1;
        flex: auto;
        background: #000000;
    }
    .ivu-menu-dark.ivu-menu-vertical .ivu-menu-opened .ivu-menu-submenu-title  {
        background: #000000;
    }
    .ivu-menu-dark.ivu-menu-vertical .ivu-menu-opened {
        background: #000000;
    }
    .ivu-upload-list{
        display: none;
    }
</style>
<div id="app" style="padding:10px 10px 0 30px">
    <div class="layout" style="margin-left: -30px;margin-top: -10px;">
        <Layout>
            <Sider breakpoint="md" collapsible :collapsed-width="78" v-model="isCollapsed">
                <h2 class="title">报表设计器</h2>
                <i-menu theme="dark" width="auto" :class="menuitemClasses" active-name="datainfo" :open-names="['sub']" @on-select="onMenuSelect">
                    <Submenu name="sub">
                        <template slot="title">
                            <Icon type="ios-apps"/></Icon>
                            报表管理
                        </template>
                        <Menu-Item name="datainfo">
                            <Icon type="md-list"/></Icon>
                            <span>数据报表</span>
                        </Menu-Item>
                        <Menu-Item name="chartinfo">
                            <Icon type="md-images"></Icon>
                            <span>图形报表</span>
                        </Menu-Item>
                        <Menu-Item name="printinfo">
                            <Icon type="md-print"></Icon>
                            <span>打印设计</span>
                        </Menu-Item>
                    </Submenu>
                </i-menu>
                <div slot="trigger"></div>
            </Sider>
            <Tabs value="name1" style="width: 100%" @on-click="loadData">
                <tab-pane icon="md-desktop" label="报表设计" name="name1">
                    <div class="page">
                        <Page :total="page.total"
                              show-total
                              show-elevator
                              :page-size="page.size"
                              show-sizer
                              @on-change="handleCurrentChange"
                              @on-page-size-change="handleSizeChange"
                              size="small">
                        </Page>
                    </div>
                    <div style="display: flex;flex-wrap: wrap;">
                        <div class="excel-view-item excel-list-add">
                            <a @click="createExcel">
                                <i class="ivu-icon ivu-icon-md-add" style="font-size:20px; padding-bottom: 5px;"></i>
                                <p style="letter-spacing: 2px;font-size: 14px;">新建报表</p>
                            </a>
                        </div>

                        <!-- 循环开始 &ndash;&gt;-->
                        <div
                                v-for="(item,index) in dataSource"
                                :key="index"
                                class="excel-view-item"
                                @mouseover="item.editable=true"
                                @mouseout="item.editable=false">

                            <!-- 缩略图 &ndash;&gt;-->
                            <div class="thumb">
                                <img src="${base}${customPrePath}/jmreport/desreport_/corelib/jiade.jpg"/>

                                <div class="excel-edit-container" v-show="item.editable">
                                    <a :href="getExcelEditUrl(item)" target="_blank">
                                        设计
                                    </a>
                                </div>
                            </div>

                            <!-- 底部 &ndash;&gt;-->
                            <div class="item-footer">
                                <span class="item-name">{{ item.name }}</span>
                                <div>
                                    <a class="opt-show" :href="getExcelViewUrl(item)" target="_blank">
                                        <Tooltip content="预览模板" placement="top">
                                            <i class="ivu-icon ivu-icon-ios-eye-outline" style="font-size: 16px"></i>
                                        </Tooltip>
                                    </a>
                                    <a class="opt-show" v-show="userMessage" @click="setTemplate(item,1)">
                                        <Tooltip content="收藏模板" placement="top">
                                            <i class="ivu-icon ivu-icon-ios-star-outline" style="font-size: 16px"></i>
                                        </Tooltip>
                                    </a>
                                    <a class="opt-show" @click="handleDelete(item)">
                                        <Tooltip content="删除模板" placement="top">
                                            <i class="ivu-icon ivu-icon-ios-trash" style="font-size: 16px"></i>
                                        </Tooltip>
                                    </a>
                                    <a class="opt-show" @click="handleCopy(item)">
                                        <Tooltip content="复制模板" placement="top-end">
                                            <i class="ivu-icon ivu-icon-ios-browsers" style="font-size: 16px"></i>
                                        </Tooltip>
                                    </a>
                                </div>

                            </div>
                        </div>
                        <!-- 循环结束 &ndash;&gt;-->
                    </div>
                </tab-pane>
                <tab-pane icon="md-options" label="模板案例" name="name2">
                    <div class="page">
                        <Page :total="page.total"
                              show-total
                              show-elevator
                              show-sizer
                              @on-change="handleCurrentChange"
                              @on-page-size-change="handleSizeChange"
                              size="small">
                        </Page>
                    </div>
                    <div style="display: flex;flex-wrap: wrap;">

                        <!-- 循环开始 &ndash;&gt;-->
                        <div
                                v-for="(item,index) in dataSource"
                                :key="index"
                                class="excel-view-item"
                                @mouseover="item.editable=true"
                                @mouseout="item.editable=false">

                            <!-- 缩略图 &ndash;&gt;-->
                            <div class="thumb">
                                <img src="${base}${customPrePath}/jmreport/desreport_/corelib/jiade.jpg"/>

                                <div class="excel-edit-container" v-show="item.editable">
                                    <a v-show="userMessage" :href="getExcelEditUrl(item)" target="_blank">
                                        设计
                                    </a>
                                </div>
                            </div>

                            <!-- 底部 &ndash;&gt;-->
                            <div class="item-footer">
                                <span class="item-name">{{ item.name }}</span>
                                <div style="margin-left: 20%;">
                                    <a class="opt-show" :href="getExcelViewUrl(item)" target="_blank">
                                        <Tooltip content="预览模板" placement="top">
                                            <i class="ivu-icon ivu-icon-ios-eye-outline" style="font-size: 16px"></i>
                                        </Tooltip>
                                    </a>
                                    <a class="opt-show" v-show="userMessage" @click="setTemplate(item,0)">
                                        <Tooltip content="取消收藏" placement="top">
                                            <i class="ivu-icon ivu-icon-ios-star" style="font-size: 16px"></i>
                                        </Tooltip>
                                    </a>
                                    <a class="opt-show" @click="handleCopy(item)">
                                        <Tooltip content="复制模板" placement="top">
                                            <i class="ivu-icon ivu-icon-ios-browsers" style="font-size: 16px"></i>
                                        </Tooltip>
                                    </a>
                                </div>
                                <div v-show="userMessage" >
                                    <Upload
                                            :headers="uploadHeader"
                                            :before-upload="handleUpload"
                                            :data="{'id':item.id}"
                                            :action="actionUrl"
                                            :format="['jpg','jpeg','png']"
                                            :on-format-error="handleFormatError"
                                            :on-exceeded-size="handleMaxSize"
                                            :on-success="handleSuccess">
                                        <Tooltip content="上传封面" placement="top-end">
                                            <i class="ivu-icon ivu-icon-md-image" style="font-size: 16px"></i>
                                        </Tooltip>
                                    </Upload>
                                </div>
                            </div>
                        </div>
                        <!-- 循环结束 &ndash;&gt;-->
                    </div>
                </tab-pane>
            </Tabs>
        </Layout>
    </div>

   <#-- <i-button @click="show">Click me!</i-button>
    <Modal v-model="visible" title="Welcome">Welcome to ViewUI</Modal>-->
</div>
<script>
    var BASE_URL="${base}"+"${customPrePath}";
    var currentPage = new Vue({
        el: '#app',
        data: {
            isCollapsed: false,
            token:'',//token
            name:'',
            designerObj:{},
            loading:true,
            showEdit:false,
            dataSource:[],
            modalTitle:"",
            page: { //分页参数
                page: 1,
                size: 10,
                total: 0,
            },
            changecode : "",
            changename : "",
            menuitem : "datainfo",
            tabpan : "name1",
            userMessage: false,
            file:null,
            uploadHeader:{},
            actionUrl:""
        },
        computed: {
            menuitemClasses: function () {
                return [
                    'menu-item',
                    this.isCollapsed ? 'collapsed-menu' : ''
                ]
            }
        },
        mounted:function(){
           this.token = token;
            console.log("list_mount--------------",this.token);
           this.uploadHeader = {"X-Access-Token":this.token};
           this.actionUrl=BASE_URL+"/jmreport/putFile";
           this.$nextTick(()=>{
                this.dataSource=[];
                this.userInfo();
            });
        },
        methods: {
            handleSizeChange(val){
                this.page.size = val;
                this.loadData();
            },
            handleCurrentChange (val) {
                this.page.page = val;
                this.loadData();
            },
            show: function () {
            },
            //查询用户信息并加载数据
            userInfo: function(){
                var that = this;
                $http.get({
                    url:api.userInfo,
                    data:{
                        token:that.token
                    },
                    success:(result)=>{
                        if (result.message != null && result.message != ""){
                            if (result.message === "admin"){
                                that.userMessage = true;
                            }
                        }
                        that.$nextTick(()=>{
                            that.loadData();
                        });
                    },
                    error:(err)=>{
                        that.handleSpinHide();
                    }
                },that)
            },
            //加载数据
            loadData: function(name){
                var that = this;
                if (name != null && name != ""){
                    that.tabpan = name;
                    that.page={page: 1,size: 10,total: 0,};
                }
                var url = "";
                that.dataSource=[];
                if (that.tabpan == "name1"){
                    url = api.excelQuery
                }else {
                    url = api.excelQueryByTemplate
                }
                $http.get({
                    url:url,
                    data:{
                        pageNo:that.page.page,
                        pageSize:that.page.size,
                        reportType:that.menuitem,
                        name:that.name,
                        token:that.token
                    },
                    success:(result)=>{
                        var ls = result.records;
                        that.page.total = result.total
                        if(ls && ls.length>0){
                            for(var i = 0;i<ls.length;i++){
                                //预览时设置报表打印宽度
                                let jsonStr = ls[i].jsonStr;
                                let width;
                                if(jsonStr){
                                    jsonStr = JSON.parse(jsonStr);
                                    width = jsonStr.printElWidth || jsonStr.dataRectWidth || 800;
                                    ls[i].printWidth = width;
                                }
                                ls[i].editable=false;
                            }
                            that.$nextTick(()=>{
                                that.dataSource =JSON.parse(JSON.stringify(ls));
                            });
                        }
                    },
                    error:(err)=>{
                        that.handleSpinHide();
                    }
                },that)
            },
            //新建报表
            createExcel: function(){
                var that = this;
                $http.post({
                    url:api.saveReport,
                    data:{},
                    contentType:'json',
                    success:(result)=>{
                        window.open(api.index+result.id+"?token="+this.token);
                    }
                },that)
            },
            //未使用
            handleEditConfig: function(item){
                window.location.href = api.index+item.id+"?token="+this.token;
            },
            //删除报表
            handleDelete:function(item){
                $http.confirm({
                    content:'是否确认删除?',
                    url:api.deleteReport,
                    data:{
                        id:item.id,
                        token:this.token
                    },
                    success:(result)=>{
                        this.loadData();
                    }
                },this);
            },
            //复制模版
            handleCopy: function(item){
                $http.confirm({
                    content:'是否确认复制?',
                    url:api.reportCopy,
                    method:'get',
                    data:{
                        id:item.id,
                        token:this.token
                    },
                    success:(result)=>{
                        this.loadData();
                    }
                },this);
            },
            handlerViewExcel: function(item){
                console.log(item)
            },
            getExcelEditUrl: function(item){
                return api.index+item.id+"?token="+this.token;
            },
            getExcelViewUrl: function(item){
                return api.view+item.id;
            },
            getLabelText1:function (createElement) {
                return createElement('div',
                    {
                        style:{color:'#fff'}
                    },
                    [
                        createElement('Icon',{props:{type:'ios-checkmark'}}),
                        '模板库'
                    ]
                )
            },
            onMenuSelect:function(name){
                this.menuitem = name;
                this.page={page: 1,size: 10,total: 0,};
                this.dataSource=[];
                this.loadData();
            },
            //设置取消模版
            setTemplate: function(item,arg){
                var title = (arg == 1)?'是否确认设置为模板?':'是否确认取消模板?';
                $http.confirm({
                    content:title,
                    url:api.setTemplate,
                    method:'get',
                    data:{
                        id:item.id,
                        template:arg,
                        token:this.token
                    },
                    success:(result)=>{
                        this.loadData();
                    }
                },this);
            },
            handleUpload (file) {
                this.file = file;
                return true;
            },
            handleFormatError (file) {
                this.$Notice.warning({
                    title: '文件格式不正确',
                    desc: '文件 ' + file.name + ' 格式不正确，请上传 jpg 或 png 格式的图片。'
                });
            },
            handleMaxSize (file) {
                this.$Notice.warning({
                    title: '超出文件大小限制',
                    desc: '文件 ' + file.name + ' 太大，不能超过 2M。'
                });
            },
            handleSuccess (res) {
                if (res != null){
                    this.$Message.success(res.message);
                    /*this.dataSource.forEach((item,index,array)=>{
                        if (item.id === res.result.id){
                            item.thumb = res.result.thumb;
                        }
                    })*/
                }
            },
            handleSpinHide(){
               /* setTimeout(() => {
                    this.$Spin.hide();
                }, 3000);*/
            }
        }
    })
</script>

<script>
    var _hmt = _hmt || [];
    (function() {
        var hm = document.createElement("script");
        hm.src = "https://hm.baidu.com/hm.js?5819d05c0869771ff6e6a81cdec5b2e8";
        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(hm, s);
    })();
</script>

</body>
</html>
