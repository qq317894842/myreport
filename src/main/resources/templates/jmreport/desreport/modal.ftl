<template>
    <Modal
            v-model="deleteParamModel"
            @on-ok="deleteParamTable"
            title="确认删除">
        <p><Icon type="ios-alert"  color="#f90" size="20px"></Icon>是否删除选中数据?</p>
    </Modal>
    <Modal
            v-model="deleteFieldModel"
            @on-ok="deleteFieldTable"
            title="确认删除">
        <p><Icon type="ios-alert"  color="#f90" size="16px"></Icon>是否删除选中配置?</p>
    </Modal>

    <!-- 新增数据集 弹框-begin -->
   <#-- <Modal
           fullscreen=true
          :loading="loading"
          width="100%"
          v-model="sqlModal"
          :title="moduleTitle"
          @on-cancel="clearDb"
          @on-ok="saveDb">
          <i-form ref="sqlForm"
                   :model="sqlForm"
                  :rules="sqlFormValidate"
                  inline :label-width="85">
            <Row>
                <i-col span="6">
                    <form-item prop="dbCode" label="编码:">
                        <i-input :disabled ="sqlForm.id!='' && sqlForm.id!=undefined" style="width: 253px" type="text" v-model="sqlForm.dbCode" placeholder="请输入编码">
                        </i-input>
                    </form-item>
                </i-col>
                <i-col span="6">
                    <form-item prop="dbChName" label="名称:">
                        <i-input type="text" style="width: 300px" v-model="sqlForm.dbChName" placeholder="请输入名称">
                        </i-input>
                    </form-item>
                </i-col>
                <i-col span="4">
                    <form-item>
                        &lt;#&ndash;<Checkbox :checked.sync="sqlForm.isPage" v-if="addIsPage == true" disabled v-model="sqlForm.isPage">是否分页</Checkbox>&ndash;&gt;
                        <Checkbox :checked.sync="sqlForm.isPage" v-model="sqlForm.isPage" @on-change="checkChange">是否分页</Checkbox>
                    </form-item>
                </i-col>
                <i-col span="6" v-if="sqlForm.dbType == 1">
                    <form-item prop="apiMethod" label="请求方式:">
                        <i-select  style="width: 253px" v-model="sqlForm.apiMethod" placeholder="请输入请求方式">
                            <i-option value="0">get</i-option>
                            <i-option value="1">post</i-option>
                        </i-select>
                    </form-item>
                </i-col>
                <i-col span="5" v-if="sqlForm.dbType == 0">
                    <form-item  label="数据源:">
                        <i-select :model.sync="sqlForm.dbSource" v-model="sqlForm.dbSource" style="width:200px" @on-change="selectdbSource">
                            <i-option v-for="item in sourceTab.data" :value="item.id">{{ item.name }}</i-option>
                        </i-select>
                    </form-item>
                </i-col>
                <i-col span="2">
                    <i-button @click="sourceManage" v-if="sqlForm.dbType == 0" type="primary">数据源维护</i-button>
                </i-col>
          </Row>
          <Row style="margin-top: 1%;">
            <i-col span="21">
                <form-item prop="dbDynSql" label="报表SQL:" v-if="sqlForm.dbType == 0">
                    <i-input v-model="sqlForm.dbDynSql"  @on-blur="dbDynSqlBlur"  type="textarea" :rows="4"  placeholder="请输入查询SQL" style="min-height: 120px;max-height: 620px;width:950px">
                    </i-input>
                </form-item>
                <form-item prop="apiUrl" label="Api地址:" v-else="sqlForm.dbType == 1">
                    <i-input v-model="sqlForm.apiUrl" type="textarea" :rows="4"  placeholder="请输入Api地址" style="min-height: 120px;max-height: 620px;width:950px">
                    </i-input>
                </form-item>
                <i-button @click="handleSQLAnalyze" v-if="sqlForm.dbType == 0" type="primary">SQL解析</i-button>
                <i-button @click="handleApiAnalyze" v-if="sqlForm.dbType == 1" type="primary">Api解析</i-button>
           </i-col>
           <i-col span="3">

           </i-col>
          </Row>
          </i-form>
          <Tabs v-model="tabValue" style="margin-top: 15px">
            <tab-pane label="动态报表配置明细" name="1">
                <i-button type="primary" @click="removeFieldTable" v-if="tab1.selectParamTables.length>0">删除</i-button>
                <i-table style="padding-bottom: 10%;" ref="dynamicTable" @on-select="selectField" @on-select-all="selectFieldAll" @on-select-all-cancel="cancelFieldAll" @on-select-cancel="cancelField" stripe :columns="tab1.columns" :data="tab1.data" :height="tableHeight"></i-table>
            </tab-pane>
            <tab-pane label="报表参数" name="2">
                <i-button type="primary" @click="addParamTable">新增</i-button>
                <i-button type="primary" @click="removeParamTable" v-if="tab2.selectParamTables.length>0">删除</i-button>
                <i-table ref="paramTable" @on-select="selectParam" @on-select-all="selectParamAll" @on-select-all-cancel="cancelParamAll" @on-select-cancel="cancelParam" stripe :columns="tab2.columns" :data="tab2.data" :height="paramTableHeight"></i-table>
            </tab-pane>
        </Tabs>
    </Modal>-->
    <!-- 新增数据集 弹框-end -->

   <#-- <Modal
            class-name="vertical-center-modal"
            fullscreen=true
            :loading="loading"
            v-model="sourceModal"
            title="数据源维护"
            @on-ok="saveSourceDb">
        <Row>
            <i-col span="3">
                <i-button @click="addDataSource" type="primary">新增</i-button>
            </i-col>
        </Row>
        <template>
            <i-table border :columns="sourceTab.columns" :data="sourceTab.data"  style="margin-top: 1%;"></i-table>
        </template>
    </Modal>-->

  <#--  <Modal :loading="loading" v-model="visibleData" title="数据源" :width="35" @on-cancel="clearDbSou" @on-ok="saveDataSource">
        <div style="padding-right: 30px">
            <i-form ref="dataSource" :model="dataSource" :rules="dataFormValidate" label-colon :label-width="100" >

                <form-item prop="name" label="数据源名称" style="height:50px">
                    <i-input v-model="dataSource.name" placeholder="请输入数据源名称"></i-input>
                </form-item>

                <form-item prop="dbType" label="数据源类型" style="height:50px">
                    <i-select :model.sync="dataSource.dbType" v-model="dataSource.dbType" @on-change="selectdbType">
                        <i-option v-for="item in dataSourceTypeList" :value="item.value">{{ item.label }}</i-option>
                    </i-select>
                </form-item>

                <form-item prop="dbDriver" label="驱动类" style="height:50px">
                    <i-input v-model="dataSource.dbDriver" placeholder="请输入驱动类"></i-input>
                </form-item>

                <form-item prop="dbUrl" label="数据源地址" style="height:50px">
                    <i-input v-model="dataSource.dbUrl" placeholder="请输入数据源地址"></i-input>
                </form-item>

                <form-item prop="dbUsername" label="用户名" style="height:50px">
                    <i-input v-model="dataSource.dbUsername" placeholder="请输入用户名"></i-input>
                </form-item>

                <form-item prop="dbPassword" label="密码" style="height:50px;width: 100%;">
                    <i-input style="width: calc(100% - 60px)" type="password" password v-model="dataSource.dbPassword" placeholder="请输入密码"></i-input>
                    <i-button size="small" style="width: 50px" @click="dataSourceTest" type="primary">测试</i-button>
                </form-item>
            </i-form>
        </div>
    </Modal>-->

    <Modal :loading="loading" v-model="visible" title="报表信息" :width="500" @on-ok="savePopup">
        <div style="padding-right: 30px">
            <i-form :model="designerObj" label-colon :label-width="90">
                <#--<form-item label="编码">
                    <i-input v-model="designerObj.code" disabled></i-input>
                </form-item>-->

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
    </Modal>

    <Modal :loading="loading" v-model="addEchart" title="数据编辑" :width="50" @on-ok="addEchartData">
        <div>
            <i-form>
                <form-item>
                    <i-input type="textarea" :autosize="{minRows: 15,maxRows: 15}" v-model="apiStaticDataList" ></i-input>
                </form-item>
            </i-form>
        </div>
    </Modal>

    <Modal :loading="loading" v-model="chartModule" title="添加图表" :width="1000" @on-ok="okAddChart" @on-cancel="selectedChartType=''">
        <Tabs value="bar" class="chart-modal-content" >
            <tab-pane :label="obj.label" :name="obj.name" v-for="(obj,index) of chartTypeList">
                <Row justify="center">
                    <i-col span="5" offset="1" v-for="(item,index) of obj.typeList" :class="item.allowed ? '':'no-allowed'" style="margin-top: 20px">
                        <div style="border: solid 1px #dcdee2;width: 180px;height: 130px;" :class="selectedChartId == item.id ? 'chart-selected':''" @click="setSelectCharType(item)" >
                            <img :src="'${base}'+'${customPrePath}'+item.imgUrl" style="width:95%;height:95%;margin: 0 5px;">
                            <span style="float: left;width:180px;margin-top: 8px;text-align:center;;font-size: 12px">{{item.name}}</span>
                        </div>
                    </i-col>
                </Row>
            </tab-pane>
        </Tabs>
    </Modal>

    <Modal :loading="loading" v-model="seriesModal" title="系列类型信息" :width="30" @on-ok="addSeriesType" @on-cancel="seriesObj={}">
        <div style="padding-right: 50px">
            <i-form :model="seriesObj" label-colon :label-width="90">
                <form-item label="系列">
                    <i-select v-model="seriesObj.name" style="width:100%" @on-change="selectmenuList" placeholder="请选择">
                        <i-option v-for="(item, index) in customColorNameList" :index="index" :value="item">{{ item }}</i-option>
                    </i-select>
                </form-item>
                <form-item  label="图表类型" v-if="selectedChartType !== 'bar.stack' && selectedChartId!='bar.negative'">
                    <i-select v-model="seriesObj.type" placeholder="请选择图表类型">
                        <i-option value="bar">柱形图</i-option>
                        <i-option value="line">折线图</i-option>
                    </i-select>
                </form-item>
                <form-item  label="堆栈类型" v-if="selectedChartType === 'bar.stack'|| selectedChartId==='bar.negative'">
                    <i-input v-model="seriesObj.stack" placeholder="请输入堆栈类型"></i-input>
                </form-item>
            </i-form>
        </div>
    </Modal>
    <#--自定义表达式弹窗-->
    <Modal :loading="loading" v-model="customExpressionShow" title="添加表达式" :width="1000" @on-ok="expressionSave" @on-cancel="expressionCancel" class="expression">
        <i-form label-colon :label-width="90">
            <Row justify="left">
                <i-col>
                    <span class="fontColor">请在下面的文本框中输入公式，不需要输入开头的等号:</span>
                </i-col>    
            </Row>
            <Row justify="center" style="margin-top: 10px">
                <i-col>
                  <i-input type="textarea" v-model="expression" placeholder="请输入表达式" class="expressionInput"></i-input> 
                </i-col>
            </Row>
            <Row justify="center" style="margin-top: 10px">
                <i-col span="6" class="functionDiv">
                    <div :class="leftFunctionIndex == 0?'leftFunctionSelect':'leftFunction'" @click="leftFunctionClick(0)">
                        <span class="fontColor">常用函数</span>
                    </div>
                </i-col>
                <i-col span="1">
                </i-col>
                <i-col span="13">
                    <div class="childrenDiv">
                        <div v-if="commonFunction" v-for="(item,index) in newFunctionList" @click="rightFunctionClick(item,index)" :class="rightFunctionIndex == index?'rightFunctionSelect':'activeItem'">
                            <span class="fontColor">{{item}}</span> 
                        </div>
                    </div>
                </i-col>
                <i-col span="5">
                   <j-function-interpretation :text="interpretation"></j-function-interpretation>
                </i-col>
            </Row>
        </i-form>
    </Modal>
</template>
