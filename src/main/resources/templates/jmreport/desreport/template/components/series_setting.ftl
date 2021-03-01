<script type="text/x-template" id="series-setting-template">
    <Submenu  name="15" style="border-bottom: inset 1px;">
        <template slot="title">
            数值设置
        </template>
        <div class="blockDiv" style="padding-bottom: 10px">
            <Row class="ivurow">
                <p>显示&nbsp;&nbsp;</p>
                <i-switch size="small" style="margin-left: 105px;" v-model="seriesOption.show" @on-change="onSeriesLabelChange"/>
            </Row>
            <Row class="ivurow">
                <p>字体大小&nbsp;&nbsp;</p>
                <i-input size="small" type="number" v-model="seriesOption.textStyle_fontSize" @on-blur="onSeriesLabelChange" style="width: 111px;"></i-input>
            </Row>
            <Row class="ivurow" v-if="typeof seriesOption.textStyle_color !== 'undefined'">
                <p>字体颜色&nbsp;&nbsp;</p>
                <Col>
                <i-input v-model="seriesOption.textStyle_color" size="small" style="width: 111px;" @on-change="onSeriesLabelChange">
                    <span slot="append">
                        <color-picker class="colorPicker" v-model="seriesOption.textStyle_color" :editable="false"  :transfer="true" size="small" @on-change="onSeriesLabelChange"/>
                    </span>
                </i-input>
                </Col>
            </Row>
            <Row class="ivurow">
                <p>字体粗细&nbsp;&nbsp;</p>
                <i-select size="small" class="iSelect" v-model="seriesOption.textStyle_fontWeight" @on-change="onSeriesLabelChange">
                    <i-option value="normal">normal</i-option>
                    <i-option value="bold">bold</i-option>
                    <i-option value="bolder">bolder</i-option>
                    <i-option value="lighter">lighter</i-option>
                </i-select>
            </Row>
            <Row class="ivurow">
                <p style="margin-bottom: 10px;">字体位置&nbsp;&nbsp;</p>
                <i-select size="small" class="iSelect" v-model="seriesOption.position" @on-change="onSeriesLabelChange">
                    <i-option v-for="(item,index) in seriesOption.labelPositionArray" :value="item.value" :index="index">
                        {{ item.text }}
                    </i-option>
                </i-select>
            </Row>
        </div>
    </Submenu>
</script>
<script>
    Vue.component('j-series-setting', {
        template: '#series-setting-template',
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
                seriesOption: {
                    textStyle_color:'',
                    textStyle_fontSize:'',
                    textStyle_fontWeight:'',
                    position:''
                },
                labelPositions:[]
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
                    this.seriesOption = Object.assign(this.seriesOption, this.settings)
                }
            },
            onSeriesLabelChange(){
                let {labelPositionArray,...otherOptions}=this.seriesOption;
                this.$emit('change', otherOptions,'label')
            }
        }
    })
</script>