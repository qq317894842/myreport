| 属性 | 类型 | 描述 |
| :---|:---:|:--- |
|showToolbar  |Boolean | 是否展示工具条|
|showGrid | Boolean| 是否展示表格|
|showContextmenu     | Boolean |是否支持右击菜单|
|readOnly     | Boolean | 是否只读|
|readOnlyCol     | Array | 设置只读列，列从0开始|
|rpBar     | Boolean/Object | 是否展示报表工具条，可以设置成布尔，对象示例如下： rpBar:{show:true,style:{'padding-left':'200px'}} |
|domain     | String | 图片上传、预览的domain地址配置|


| 事件 | 参数 | 描述 |
| :---         |     :---:      |          :--- |
|onAddChart  | postion     | 点击插入图表小图标触发事件,  参数postion是鼠标选中单元格的位置信息    |
|onSelectChart     | options, url      | 点击图表触发选中事件，option为图表的配置,url为数据请求地址      |
|onSave     | data      | 点击保存触发事件,参数data为当前excel实例需要保存的json对象      |


| 方法 | 参数 | 描述 |
| :---         |     :---:      |          :--- |
|addChart     | options, url      | 从外部插入图表，option为图表的配置,url为数据请求地址      |
|refreshChart     | url      | 通过设置新的url请求数据刷新表格(需先选中表格)      |
|updateChart     | options, url      | 通过设置url和options 刷新表格(需先选中表格)      |
|tip     | msg      | 提示，参数msg为需要提示的信息      |



备注：  
图表的series格式可能有如下几类：  
```
//格式一  单维度 
series: [{
        data: [1, 2, 3, 4, 5],
        type: 'line'
    }]

//格式二  多维度
series: [{
            name: 'xxxx1',
            data:[1,2,3,4,5]
        },
        {
            name: 'xxx2',
            data:[5,6,7,8,9]
        }]

// 格式三
series: [{
            name: '访问来源',
            data: [
                {value: 1, name: '1'},
                {value: 2, name: '2'},
                {value: 3, name: '3'},
                {value: 4, name: '4'},
                {value: 5, name: '5'}
            ]
        }]
    
总结：
series本身是一个数组，每个元素由name,data组成，若没有name，则这个series长度一定为1，
data是一个数组，数组元素可能是数字，也可能是对象，这个是后台请求需要处理的事

现定义，后台请求返回值遵循的约定：
1.后台返回一个数组,数组元素是一个对象,对象必须包括一个data属性,多维度则需要设定name
2.如果数组长度等于1，则设定series[0].data = res.result[0].data
3.如果数组长度大于1，则根据name匹配series中的name，再设定对应的data。
```




