<script type="text/x-template" id="legend-setting-template">
    <div>
        <Submenu  name="legend" style="border-bottom: inset 1px;">
            <template slot="title">
                图例设置
            </template>
            <div class="blockDiv">
                <Row class="ivurow">
                    <p>显示&nbsp;&nbsp;</p>
                    <i-switch size="small" style="margin-left: 105px;" v-model="legendOptions.show" @on-change="onLegendChange"/>
                </Row>
                <Row class="ivurow">
                    <p>字体大小&nbsp;&nbsp;</p>
                    <i-input size="small" type="number" v-model="legendOptions.textStyle_fontSize" @on-blur="onLegendChange" style="width: 111px;"></i-input>
                </Row>
                <Row class="ivurow" v-if="typeof legendOptions.textStyle_color !== 'undefined'">
                    <p>字体颜色&nbsp;&nbsp;</p>
                    <Col>
                    <i-input v-model="legendOptions.textStyle_color" size="small" style="width: 111px;" @on-change="onLegendChange">
                           <span slot="append">
                             <color-picker class="colorPicker" v-model="legendOptions.textStyle_color" :editable="false" alpha  :transfer="true" size="small" @on-change="onLegendChange"/>
                           </span>
                    </i-input>
                    </Col>
                </Row>
                <#--<Row class="ivurow">
                    <p>图例宽度&nbsp;&nbsp;</p>
                    <i-input size="small" type="number" v-model="echartInfo.legendItemWidth" @on-blur="styleChanges" style="width: 111px;margin-bottom: 10px;"></i-input>
                </Row>-->
                <Row class="ivurow">
                    <p>纵向位置&nbsp;&nbsp;</p>
                    <i-select size="small" style="width: 180%;" v-model="legendOptions.top" @on-change="onLegendChange">
                        <i-option value="top">顶部</i-option>
                        <i-option value="bottom">底部</i-option>
                    </i-select>
                </Row>
                <Row class="ivurow">
                    <p style="margin-bottom: 10px;">横向位置&nbsp;&nbsp;</p>
                    <i-select size="small" class="iSelect" v-model="legendOptions.left" @on-change="onLegendChange">
                        <i-option value="left">左对齐</i-option>
                        <i-option value="center">居中</i-option>
                        <i-option value="right">右对齐</i-option>
                    </i-select>
                </Row>
                <Row class="ivurow">
                    <p style="margin-bottom: 10px;">布局朝向&nbsp;&nbsp;</p>
                    <i-select size="small" style="width: 180%;" v-model="legendOptions.orient" @on-change="onLegendChange">
                        <i-option value="horizontal">横排</i-option>
                        <i-option value="vertical">竖排</i-option>
                    </i-select>
                </Row>
            </div>
        </Submenu>
    </div>
</script>
<script>
    Vue.component('j-legend-setting', {
        template: '#legend-setting-template',
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
                legendOptions: {
                    textStyle_color:'',
                    top:"top",
                    left:"left",
                    orient:"horizontal",
                    textStyle_fontSize:""
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
        methods: {
            initData: function (){
                if (this.settings){
                    this.legendOptions = Object.assign(this.legendOptions, this.settings)
                }
            },
            onLegendChange (){
                console.log("我进来了")
                console.log(this.legendOptions)
                this.$emit('change','legend',this.legendOptions)
            }
        }
    })
</script>