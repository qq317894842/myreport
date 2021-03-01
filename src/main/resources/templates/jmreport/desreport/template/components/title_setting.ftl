<script type="text/x-template" id="title-setting-template">
    <div >
        <Submenu name="1" style="border-bottom: inset 1px;">
            <template slot="title">标题设置</template>
            <div class="blockDiv">
                <Row class="ivurow">
                    <p>显示&nbsp;&nbsp;</p>
                    <i-switch size="small" style="margin-left: 105px;" v-model="titleOption.show" @on-change="onTitleChange"/>
                </Row>

                <Row class="ivurow">
                    <p>标题文字&nbsp;&nbsp;</p>
                    <i-input size="small" v-model="titleOption.text" @on-blur="onTitleChange" style="width: 111px;"></i-input>
                </Row>
                <Row class="ivurow" v-if="typeof titleOption.textStyle_color !== 'undefined'">
                    <p>字体颜色&nbsp;&nbsp;</p>
                    <Col>
                    <i-input v-model="titleOption.textStyle_color" size="small" style="width: 111px;" @on-change="onTitleChange">
                    <span slot="append">
                        <color-picker class="colorPicker" v-model="titleOption.textStyle_color" :editable="false"  :transfer="true" size="small" @on-change="onTitleChange"/>
                    </span>
                    </i-input>
                    </Col>
                </Row>
                <Row class="ivurow">
                    <p>字体加粗&nbsp;&nbsp;</p>
                    <#--:model.sync="echartInfo.titleFontWeight"-->
                    <i-select size="small" class="iSelect" v-model="titleOption.textStyle_fontWeight" @on-change="onTitleChange">
                        <i-option value="normal">normal</i-option>
                        <i-option value="bold">bold</i-option>
                        <i-option value="bolder">bolder</i-option>
                        <i-option value="lighter">lighter</i-option>
                    </i-select>
                </Row>
                <Row class="ivurow">
                    <p>字体大小&nbsp;&nbsp;</p>
                    <i-input size="small" type="number" v-model="titleOption.textStyle_fontSize" @on-change="onTitleChange"
                             style="width: 111px;"></i-input>
                </Row>
                <Row class="ivurow">
                    <p style="margin-bottom: 10px;">标题位置&nbsp;&nbsp;</p>
                    <i-select size="small" class="iSelect" v-model="titleOption.left" @on-change="onTitleChange">
                        <i-option value="left">left</i-option>
                        <i-option value="center">center</i-option>
                        <i-option value="right">right</i-option>
                    </i-select>
                </Row>
                <Row class="ivurow">
                    <p>顶边距&nbsp;&nbsp;</p>
                    <slider v-model="titleOption.top" @on-change="onTitleChange" :tip-format="formatTop" style="margin-top: -9px;width: 120px;margin-left: 5px;"></slider>
                </Row>
            </div>
        </Submenu>
    </div>
</script>
<script>
    Vue.component('j-title-setting', {
        template: '#title-setting-template',
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
                titleOption: {
                    show: true,
                    top: 5,
                    text: '',
                    textStyle_color: '',
                    textStyle_fontWeight: '',
                    textStyle_fontWeight: '',
                    textStyle_fontSize: '',
                    left: ''
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
            formatTop(val){
                return val + 'px';
            },
            initData: function (){
                if (this.settings){
                    this.titleOption = Object.assign(this.titleOption, this.settings)
                }
            },
            onTitleChange(){
                this.$emit('change', 'title', this.titleOption)
            }
        }
    })
</script>