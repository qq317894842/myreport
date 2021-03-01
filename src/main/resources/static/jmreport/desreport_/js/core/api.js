function getUrl(url){
    return `${baseFull}/jmreport` + url;
}
//拼接待tokenurl
function getHasTokenUrl(url, id){
    if (id){
        return `${baseFull}/jmreport${url}/${id}?token=${token}`;
    }else{
        return `${baseFull}/jmreport${url}?token=${token}`;
    }
}
//拼接待域名url
function getOrigin(url){
    return `${baseFull}/jmreport` + url;
}

const api = {
    //首页
    index: getUrl('/index/'),
    //预览界面
    view: getUrl('/view/'),
    //查询用户名
    userInfo: getUrl('/userinfo'),

    /********************************************报表接口********************************************/
    //查询报表
    excelQuery: getUrl('/excelQuery'),
    //查询报表
    excelQueryByTemplate: getUrl('/excelQueryByTemplate'),
    //保存报表
    saveReport: getUrl('/save'),
    //报表预览
    show: getOrigin('/show'),
    //删除报表
    deleteReport: getUrl('/delete'),
    //图表复制
    reportCopy: getUrl('/reportCopy'),
    //返回图表json配置
    addChart: getUrl('/addChart'),
    //设置模版
    setTemplate: getUrl('/setTemplate'),
    //检测报名名字是否存在
    excelQueryName: getUrl('/excelQueryName'),
    //加载数据源表信息
    loadTable: getUrl('/loadTable'),
    //加载数据源表数据信息
    loadTableData: getUrl('/loadTableData'),
    //解析sql
    //executeSelectSql: getUrl('/executeSelectSql'),
    // 解析api
    executeSelectApi: getHasTokenUrl('/executeSelectApi'),
    //解析sql获取列
    queryFieldBySql: getUrl('/queryFieldBySql'),

    //校验数据集编码唯一性
    dataCodeExist: getUrl('/dataCodeExist'),
    //获取查询条件信息
    getQueryInfo: getUrl('/getQueryInfo'),

    //导出全部excel
    exportAllExcel: getOrigin('/exportAllExcel'),
    //预览次数
    addViewCount(id){
        return getOrigin('/addViewCount') + '/' + id;
    },
    //确定是否有参数
    checkParam(id){
        return getOrigin('/checkParam') + '/' + id;
    },
    //查询报表
    getReport(id){
        return getHasTokenUrl('/get', id);
    },
    queryIsPage(id){
        return getHasTokenUrl('/queryIsPage', id);
    },
    /********************************************数据源数据集接口********************************************/
    //初始化数据源
    initDataSource:getHasTokenUrl('/initDataSource'),
    //添加数据源
    addDataSource: getUrl('/addDataSource'),
    //删除数据源
    delDataSource: getUrl('/delDataSource'),
    //测试数据源连接
    testConnection: getUrl('/testConnection'),
    //批量删除报表参数
    deleteParamByIds: getUrl('/deleteParamByIds'),
    //批量删除报表参数
    deleteFieldByIds: getUrl('/deleteFieldByIds'),
    //根据sql查询数据集
    qurestSql: getUrl('/qurestSql'),
    //根据接口查询数据集
    qurestApi: getHasTokenUrl('/qurestApi'),
    //查询数据集
    loadDbData: getUrl('/loadDbData'),
    //报错数据集
    saveDb: getUrl('/saveDb'),
    //删除数据集
    delDbData(dbId){
        return getHasTokenUrl('/delDbData', dbId);
    },

    //查询数据集
    loadDbData(dbId){
        return getHasTokenUrl('/loadDbData', dbId);
    },
    //渲染报表树
    fieldTreeUrl(id){
        return getHasTokenUrl('/field/tree', id);
    },
    /********************************************地图接口********************************************/
    //地图列表
    mapList:getUrl('/map/mapList'),
    //添加地图
    addMapData:getUrl('/map/addMapData'),
    //删除地图
    delMapSource:getUrl('/map/delMapSource'),
    //根据code查询地图
    queryMapByCode:getUrl('/map/queryMapByCode'),
    //根据code查询地图
    queryMapByCodeUseOrigin: getOrigin('/map/queryMapByCode'),
    /*********************字典接口*************************/
    //获取字典全部接口
    dictList: getUrl('/dict/list'),
    //字典主表新增
    dictAdd: getUrl('/dict/add'),
    //字典编辑
    dictEdit: getUrl('/dict/edit'),
    //字典删除
    dictDelete: getUrl('/dict/delete'),
    //批量删除
    dictDeleteBatch: getUrl('/dict/deleteBatch'),
    //获取字典详细全部接口
    dictItemList: getUrl('/dictItem/list'),
    //字典详细编辑
    dictItemEdit: getUrl('/dictItem/edit'),
    //字典详细新增
    dictItemAdd: getUrl('/dictItem/add'),
    //字典详细删除
    dictItemDelete: getUrl('/dictItem/delete'),
    //字典刷新缓存
    refleshCache: getUrl('/dict/refleshCache'),
    //获取字典回收站逻辑删除的数据
    deleteList: getUrl('/dict/deleteList'),
    //字典回收站取回
    back: getUrl('/dict/back'),
    //字典回收站逻辑删除的数据
    thoroughDelete: getUrl('/dict/thoroughDelete')
}
