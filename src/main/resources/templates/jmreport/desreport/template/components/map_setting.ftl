<style>
    /*地图相关样式 -begin*/
    .page{
        float:right;
        margin-top:20px;
    }
    .vertical-center-modal-big{
        margin: 2% 4%;
    }
    .ivu-modal-confirm-head-icon {
        font-size: 28px;
    }
    /*地图相关样式 -end*/
</style>
<script type="text/x-template" id="map-setting-template">
    <div>
        <Submenu name="10" style="border-bottom: inset 1px;">
            <template slot="title">
                地图设置
            </template>
            <div class="blockDiv">
                <Row class="ivurow">
                    <p>地图&nbsp;&nbsp;</p>
                    <div style="display:flex">
                        <i-select size="small" class="iSelect" v-model="mapOption.map"  @on-change="onGeoChange" style="width:110px">
                            <i-option v-for="(map,index) in allMapList" :value="map.name" :index="index">
                                {{ map.label.substr(0,5) }}
                            </i-option>
                        </i-select>
                        <i-button @click="mapManage(true)" type="primary"  size="small" style="margin-left: 5px">维护</i-button>
                    </div>
                </Row>
                <Row class="ivurow">
                    <p>比例&nbsp;&nbsp;</p>
                    <slider v-model="mapOption.zoom" step="0.1"  max="2" @on-change="onGeoChange" style="margin-top: -9px;width: 120px;margin-left: 5px;"></slider>
                </Row>
                <Row class="ivurow">
                    <p>字体大小&nbsp;&nbsp;</p>
                    <i-input size="small" type="number" v-model="mapOption.label_fontSize" @on-blur="onGeoChange" style="width: 111px;"></i-input>
                </Row>
                <Row class="ivurow" v-if="typeof mapOption.label_color !== 'undefined'">
                    <p>字体颜色&nbsp;&nbsp;</p>
                    <Col>
                    <i-input v-model="mapOption.label_color" size="small" style="width: 111px;" @on-change="onGeoChange">
                    <span slot="append">
                        <color-picker class="colorPicker" v-model="mapOption.label_color" :editable="false" alpha  :transfer="true" size="small" @on-change="onGeoChange"/>
                    </span>
                    </i-input>
                    </Col>
                </Row>
                <Row class="ivurow" v-if="typeof mapOption.emphasis_label_color !== 'undefined'">
                    <p>字体高亮颜色&nbsp;&nbsp;</p>
                    <Col>
                    <i-input v-model="mapOption.emphasis_label_color" size="small" style="width: 111px;" @on-change="onGeoChange">
                    <span slot="append">
                        <color-picker class="colorPicker" v-model="mapOption.emphasis_label_color" :editable="false" alpha  :transfer="true" size="small" @on-change="onGeoChange"/>
                    </span>
                    </i-input>
                    </Col>
                </Row>
                <Row class="ivurow">
                    <p>区域线&nbsp;&nbsp;</p>
                    <slider v-model="mapOption.itemStyle_borderWidth" step="0.1" max="5" @on-change="onGeoChange" style="margin-top: -9px;width: 120px;margin-left: 5px;"></slider>
                </Row>
                <Row class="ivurow" v-if="typeof mapOption.itemStyle_areaColor !== 'undefined'">
                    <p>区域颜色&nbsp;&nbsp;</p>
                    <Col>
                    <i-input v-model="mapOption.itemStyle_areaColor" size="small" style="width: 111px;" @on-change="onGeoChange">
                    <span slot="append">
                        <color-picker class="colorPicker" v-model="mapOption.itemStyle_areaColor" :editable="false" alpha  :transfer="true" size="small" @on-change="onGeoChange"/>
                    </span>
                    </i-input>
                    </Col>
                </Row>
                <Row class="ivurow" v-if="typeof mapOption.emphasis_itemStyle_areaColor !== 'undefined'">
                    <p>区域高亮颜色&nbsp;&nbsp;</p>
                    <Col>
                    <i-input v-model="mapOption.emphasis_itemStyle_areaColor" size="small" style="width: 111px;" @on-change="onGeoChange">
                    <span slot="append">
                        <color-picker class="colorPicker" v-model="mapOption.emphasis_itemStyle_areaColor" :editable="false" alpha  :transfer="true" size="small" @on-change="onGeoChange"/>
                    </span>
                    </i-input>
                    </Col>
                </Row>
                <Row class="ivurow" v-if="typeof mapOption.itemStyle_borderColor !== 'undefined'">
                    <p>边框颜色&nbsp;&nbsp;</p>
                    <Col>
                    <i-input v-model="mapOption.itemStyle_borderColor" size="small" style="width: 111px;" @on-change="onGeoChange">
                    <span slot="append">
                        <color-picker class="colorPicker" v-model="mapOption.itemStyle_borderColor" :editable="false" alpha  :transfer="true" size="small" @on-change="onGeoChange"/>
                    </span>
                    </i-input>
                    </Col>
                </Row>
            </div>
        </Submenu>
        <#--地图弹窗-->
        <div>
            <Modal
                    class-name="vertical-center-modal-big"
                    fullscreen=true
                    :loading="loading"
                    v-model="mapListModal"
                    title="地图维护"
                    @on-cancel="callMapDb">
                <i-form inline :label-width="85">
                    <Row >
                        <i-col span="6">
                            <form-item label="名称:">
                                <i-input  style="width: 253px" type="text" v-model="queryParams.label" placeholder="请输入名称">
                                </i-input>
                            </form-item>
                        </i-col>
                        <i-col span="6">
                            <form-item label="编码:">
                                <i-input type="text" style="width: 300px" v-model="queryParams.name" placeholder="请输入编码">
                                </i-input>
                            </form-item>
                        </i-col>
                        <i-col span="2">
                            <i-button @click="loadData(1)"  type="primary" icon="ios-search">查询</i-button>
                        </i-col>
                        <i-col span="2">
                            <i-button @click="clearQuery"  type="primary" icon="ios-refresh">重置</i-button>
                        </i-col>
                    </Row>
                </i-form>
                <Row style="margin-top:25px">
                    <i-col span="3">
                        <i-button @click="addMapData" type="primary">新增</i-button>
                    </i-col>
                </Row>
                <template>
                    <i-table border stripe :columns="mapTab.columns" :data="mapTab.data"  style="margin-top: 1%;"></i-table>
                    <div class="page">
                        <Page :total="page.total"
                              show-total
                              show-elevator
                              @on-change="handleCurrentChange"
                              @on-page-size-change="handleSizeChange">
                        </Page>
                    </div>
                </template>
                <template slot="footer">
                    <i-button type="primary" @click="callMapDb">关闭</i-button>
                </template>
            </Modal>

            <Modal :loading="loading" v-model="mapDataModal" title="数据源" :width="35" @on-cancel="clearMapDb" @on-ok="saveMapDb">
                <div style="padding-right: 30px">
                    <i-form ref="mapSource" :model="mapSource" :rules="dataFormValidate" label-colon :label-width="100" >

                        <form-item prop="label" label="地图名称" style="height:50px">
                            <i-input v-model="mapSource.label" placeholder="请输入地图名称"></i-input>
                        </form-item>

                        <form-item prop="name" label="地图编码" style="height:50px">
                            <i-input v-model="mapSource.name" placeholder="请输入地图编码"></i-input>
                        </form-item>

                        <form-item prop="data" label="地图数据">
                            <i-input type="textarea" :autosize="{minRows: 15,maxRows:15}"  v-model="mapSource.data"  placeholder="请输入地图数据"></i-input>
                            <a href="http://datav.aliyun.com/tools/atlas" target="_blank">地图数据json下载</a>
                        </form-item>

                    </i-form>
                </div>
            </Modal>
        </div>
    </div>
</script>

<script>
    Vue.component('j-map-setting', {
        template: '#map-setting-template',
        props: {
            settings: {
                type: Object,
                required: true,
                default: () => {
                }
            }
        },
        data(){
            return {
                mapOption: {
                    map:'china',
                    zoom:0.5,
                    label_color:'#000',
                    label_fontSize:12,
                    itemStyle_borderWidth :0.5,
                    itemStyle_areaColor :'#fff',
                    itemStyle_borderColor:'#000',
                    emphasis_label_color:'#fff',
                    emphasis_itemStyle_areaColor:'red'
                },
                mapListModal:false,
                mapList:[],
                allMapList:[],
                loading:true,
                mapDataModal: false,
                mapListModal: false,
                page: { //分页参数
                    page: 1,
                    size: 10,
                    total: 0,
                },
                queryParams:{
                    label:"",
                    name:"",
                },
                mapSource:{
                    id:"",
                    label:"",
                    name:"",
                    data:""
                },
                dataFormValidate:{
                    label:[
                        { required: true, message: '地图名称不能为空', trigger: 'blur' }
                    ],
                    name:[
                        { required: true, message: '地图编码不能为空', trigger: 'blur' }
                    ],
                    data:[
                        { required: true, message: '地图数据不能为空', trigger: 'blur' }
                    ]
                },
                mapTab:{
                    data: [],
                    columns: [
                        {
                            type: 'index',
                            title: '序号',
                            width: 80,
                            align: 'center'
                        },
                        {
                            title: '地图名称',
                            key: 'label'
                        },
                        {
                            title: '地图编码',
                            key: 'name'
                        },
                        {
                            title: '操作',
                            key: 'action',
                            width: 150,
                            align: 'center',
                            render: (h, params) => {
                                return this.renderButton(h, params);
                            }
                        }
                    ]
                }
            }
        },
        watch: {
            settings: {
                deep: true,
                immediate: true,
                handler: function (){
                    this.initData()
                }
            }
        },
        mounted : function() {
            this.loadAllData()
        },
        methods: {
            initData: function (){
                if (this.settings){
                    this.mapOption = Object.assign(this.mapOption, this.settings)
                }
            },
            onGeoChange(){
                this.$emit('change','geo',this.mapOption)
            },
            //地图数据集维护Modal
            mapManage(flag){
                this.clearQuery();
                this.mapListModal=flag;
            },
            loadData(){
                //加载数据列表
                let that=this;
                $http.get({
                    url: api.mapList,
                    data:{
                        label:that.queryParams.label,
                        name:that.queryParams.name,
                        current:that.page.page,
                        size:that.page.size,
                        token:this.token
                    },
                    success:(result)=>{
                        console.log('result',result)
                        let records=result.records;
                        that.page.total = result.total
                        that.$nextTick(()=>{
                            that.mapTab.data=JSON.parse(JSON.stringify(records));
                        });
                        that.mapList = records && records.length>0?records:mapTypeList;
                    }
                });
            },
            loadAllData(){
                $http.get({
                    url: api.mapList,
                    data:{
                        current:1,
                        size:1000,
                        token:this.token
                    },
                    success:(result)=>{
                        let records=result.records;
                        console.log('records===>>>',records);
                        this.allMapList = records && records.length>0?records:mapTypeList;
                    }
                });
            },
            handleSizeChange(val){
                this.page.size = val;
                this.loadData();
            },
            handleCurrentChange (val) {
                this.page.page = val;
                this.loadData();
            },
            saveMapDb() {
                //保存地图数据
                this.$refs.mapSource.validate((valid)=>{
                    if(valid){
                        //保存地图表单数据
                        $http.post({
                            contentType:'json',
                            url: api.addMapData,
                            data:JSON.stringify(this.mapSource),
                            success:(res)=>{
                                this.$Notice.success({
                                    title: '保存成功'
                                });
                                this.clearMapDb()
                                this.loadData();
                            }
                        });
                        return;
                    }else{
                        setTimeout(() => {
                            this.loading = false
                            this.$nextTick(() => {
                                this.loading = true
                            })
                        }, 500)
                        return;
                    }
                });
            },
            clearMapDb(){
                this.mapDataModal = false;
            },
            callMapDb() {
                this.loadAllData();
                this.mapManage(false)
            },
            addMapData() {
                //新增地图
                this.mapDataModal=true;
            },
            clearQuery(){
                //清除地图查询数据
                for(let key in this.queryParams){
                    this.queryParams[key] = "";
                }
                this.page.page=1;
                this.page.size=10;
                this.loadData();
            },
            //渲染删除编辑button
            renderButton(h, params) {
                return h('div',[
                    h('i-button', {
                        props: {
                            type: 'primary',
                            size: 'small'
                        },
                        style:{
                            'margin-right':'5px'
                        },
                        on: {
                            click: () => {
                                this.mapTab.data.forEach((item)=>{
                                    if (item.id === params.row.id){
                                        this.mapSource = item;
                                    }
                                })
                                this.mapDataModal = true;
                            }
                        }
                    },'编辑'),
                    h('i-button', {
                        props: {
                            type: 'primary',
                            size: 'small'
                        },
                        on: {
                            click: () => {
                                this.$Modal.confirm({
                                    title:"提示",
                                    content: '是否确认删除?',
                                    onOk: () => {
                                        let mapSource = {};
                                        mapSource.id = params.row.id;
                                        $http.post({
                                            contentType:'json',
                                            url: api.delMapSource,
                                            data:JSON.stringify(mapSource),
                                            success:(result)=>{
                                                this.$Notice.success({
                                                    title: '删除成功'
                                                });
                                                this.loadData();
                                            }
                                        });
                                    }
                                });
                            }
                        }
                    },'删除')
                ])
            },
        }
    })

    //初始化地图数据
    function loadMap(item){
        let config = JSON.parse(item.config);
        $http.post({
            contentType:'json',
            url: api.queryMapByCode,
            data:JSON.stringify({name:config.geo.map}),
            success:(result)=>{
                let data=JSON.parse(result.data);
                xs.registerMap(result.name,data);
                xs.updateChart(item.layer_id ,config);
            }
        });
    }
</script>