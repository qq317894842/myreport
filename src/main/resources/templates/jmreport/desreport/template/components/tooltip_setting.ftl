<script type="text/x-template" id="tooltip-setting-template">
    <div>
        <Submenu  name="16" style="border-bottom: inset 1px;">
            <template slot="title">
                提示语设置
            </template>
            <div class="blockDiv">
                <Row class="ivurow">
                    <p>显示&nbsp;&nbsp;</p>
                    <i-switch size="small" style="margin-left: 105px;" v-model="tooltipOption.show" @on-change="onTooltipChange"/>
                </Row>
                <Row class="ivurow">
                    <p>字体大小&nbsp;&nbsp;</p>
                    <i-input size="small" type="number" v-model="tooltipOption.textStyle_fontSize" @on-blur="onTooltipChange" style="width: 111px;"></i-input>
                </Row>
                <Row class="ivurow" v-if="typeof tooltipOption.textStyle_color !== 'undefined'">
                    <p style="margin-bottom: 10px;">字体颜色&nbsp;&nbsp;</p>
                    <Col>
                    <i-input v-model="tooltipOption.textStyle_color" size="small" style="width: 111px;" @on-change="onTooltipChange">
                    <span slot="append">
                        <color-picker class="colorPicker" v-model="tooltipOption.textStyle_color" :editable="false"  :transfer="true" size="small" @on-change="onTooltipChange"/>
                    </span>
                    </i-input>
                    </Col>
                </Row>
            </div>
        </Submenu>
    </div>
</script>
<script>
    Vue.component('j-tooltip-setting', {
        template: '#tooltip-setting-template',
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
                tooltipOption: {
                    textStyle_color: ''
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
                    this.tooltipOption = Object.assign(this.tooltipOption, this.settings)
                }
            },
            onTooltipChange(){
                this.$emit('change', 'tooltip', this.tooltipOption)
            }
        }
    })
</script>