!function(e){var t={};function r(n){if(t[n])return t[n].exports;var o=t[n]={i:n,l:!1,exports:{}};return e[n].call(o.exports,o,o.exports,r),o.l=!0,o.exports}r.m=e,r.c=t,r.d=function(e,t,n){r.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:n})},r.r=function(e){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},r.t=function(e,t){if(1&t&&(e=r(e)),8&t)return e;if(4&t&&"object"==typeof e&&e&&e.__esModule)return e;var n=Object.create(null);if(r.r(n),Object.defineProperty(n,"default",{enumerable:!0,value:e}),2&t&&"string"!=typeof e)for(var o in e)r.d(n,o,function(t){return e[t]}.bind(null,o));return n},r.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};return r.d(t,"a",t),t},r.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},r.p="",r(r.s=3)}({3:function(e,t,r){"use strict";r.r(t);const n={toolbar:{undo:"撤销",redo:"恢复",save:"保存",print:"打印",chart:"图表",img:"插入图片",barcode:"条形码",qrcode:"二维码",paintformat:"格式刷",clearformat:"清除格式",format:"数据格式",fontName:"字体",fontSize:"字号",fontBold:"加粗",fontItalic:"倾斜",underline:"下划线",strike:"删除线",color:"字体颜色",bgcolor:"填充颜色",border:"边框",merge:"合并单元格",align:"水平对齐",valign:"垂直对齐",textwrap:"自动换行",freeze:"冻结",autofilter:"自动筛选",formula:"函数",more:"更多",view:"预览",uploadExcel:"上传excel",toolPrintSize:"纸张设置",cellProp:"单元格设置",cellExp:"单元格表达式",cellLine:"单元格斜线"},rpBar:{exportExcel:"exportExcel",exportExcel_page:"导出当前页",exportExcel_all:"导出excel",exportExcel_pdf:"导出pdf",last:"上一页",next:"下一页",first:"首页",end:"末页",print:"打印",print_screen:"打印当前页",print_all:"打印全部",export:"导出",pdf:"PDF",slider:"清晰度"},contextmenu:{copy:"复制",cut:"剪切",paste:"粘贴",cellExp:"单元格表达式",cellLine:"单元格斜线",pasteValue:"粘贴数据",pasteFormat:"粘贴格式",insertRow:"插入行",insertColumn:"插入列",deleteRow:"删除行",deleteColumn:"删除列",deleteCell:"删除",deleteCellText:"删除数据",validation:"数据验证",cancleBackend:"取消套打",background:"背景图设置",loopBlock:"循环块",setting:"设定",cancel:"取消"},format:{normal:"正常",text:"文本",number:"数值",percent:"百分比",rmb:"人民币",usd:"美元",eur:"欧元",date:"短日期",date2:"长日期",time:"时间",datetime:"日期+时间",duration:"持续时间",img:"图片",barcode:"条形码",qrcode:"二维码"},formula:{sum:"求和",avg:"求平均值",max:"求最大值",min:"求最小值",dbsum:"数据集求和",dbavg:"数据集平均值",dbmax:"数据集最大值",dbmin:"数据集最小值",concat:"字符拼接",_if:"条件判断",and:"和",or:"或"},validation:{required:"此值必填",notMatch:"此值不匹配验证规则",between:"此值应在 {} 和 {} 之间",notBetween:"此值不应在 {} 和 {} 之间",notIn:"此值不在列表中",equal:"此值应该等于 {}",notEqual:"此值不应该等于 {}",lessThan:"此值应该小于 {}",lessThanEqual:"此值应该小于等于 {}",greaterThan:"此值应该大于 {}",greaterThanEqual:"此值应该大于等于 {}"},error:{pasteForMergedCell:"无法对合并的单元格执行此操作"},calendar:{weeks:["日","一","二","三","四","五","六"],months:["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"]},button:{cancel:"取消",remove:"删除",save:"保存",ok:"确认"},sort:{desc:"降序",asc:"升序"},filter:{empty:"空白"},dataValidation:{mode:"模式",range:"单元区间",criteria:"条件",modeType:{cell:"单元格",column:"列模式",row:"行模式"},type:{list:"列表",number:"数字",date:"日期",phone:"手机号",email:"电子邮件"},operator:{be:"在区间",nbe:"不在区间",lt:"小于",lte:"小于等于",gt:"大于",gte:"大于等于",eq:"等于",neq:"不等于"}}};window&&window.x&&window.x.spreadsheet&&(window.x.spreadsheet.$messages=window.x.spreadsheet.$messages||{},window.x.spreadsheet.$messages["zh-cn"]=n),t.default=n}});