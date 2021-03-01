<script type="text/x-template" id="function-interpretation">
  <div>
     <div v-if="text=='SUM'" class="interpretation">
        <p>函数描述： 对可单元格或集合表达式求最大值</p>
        <p>示例：</p>
        <p>例1：SUM(C6),对C6单元格或数据集合求最大值</p>
        <p>例2：SUM(A6,C6)，对A6和C6单元格计算最大值</p>
        <p>例3：SUM(A6:C6)，对A6到C6单元格计算最大值</p>
     </div>
    <div v-if="text=='DBSUM'" class="interpretation">
      <p>函数描述： 对可扩展单元格集合所有数据进行求和</p>
      <p>示例：</p>
      <p>DBSUM（a.name）,a.name 这个单元格所有数据求和</p>
    </div>
    <div v-if="text=='AVERAGE'" class="interpretation">
      <p>函数描述： 对可单元格或集合表达式求平均值</p>
      <p>示例：</p>
      <p>例1：AVERAGE(C6),对C6单元格或数据集合求平均值</p>
      <p>例2：AVERAGE(A6,C6)，对A6和C6单元格计算平均值</p>
      <p>例3：AVERAGE(A6:C6)，对A6到C6单元格计算平均值</p>
    </div>
    <div v-if="text=='DBAVERAGE'" class="interpretation">
      <p>函数描述： 对可扩展单元格集合所有数据进行求平均值</p>
      <p>示例：</p>
      <p>DBAVERAGE(db.salary)，对编码为db的数据集中的字段salary进行平均值计算</p>
    </div>
    <div v-if="text=='MAX'" class="interpretation">
      <p>函数描述： 对可单元格或集合表达式求最大值</p>
      <p>示例：</p>
      <p>例1：MAX(C6),对C6单元格或数据集合求最大值</p>
      <p>例2：MAX(A6,C6)，对A6和C6单元格计算最大值</p>
      <p>例3：MAX(A6:C6)，对A6到C6单元格计算最大值</p>
    </div>
    <div v-if="text=='DBMAX'" class="interpretation">
      <p>函数描述： 对可扩展单元格集合所有数据进行求最大值</p>
      <p>示例：</p>
      <p>DBMAX(db.salary)，对编码为db的数据集中的字段salary进行最大值计算</p>
    </div> 
    <div v-if="text=='MIN'" class="interpretation">
      <p>函数描述： 对可单元格或集合表达式求最小值</p>
      <p>示例：</p>
      <p>例1：MIN(C6),对C6单元格或数据集合求最小值</p>
      <p>例2：MIN(A6,C6)，对A6和C6单元格计算最小值</p>
      <p>例3：MIN(A6:C6)，对A6到C6单元格计算最小值</p>
    </div>  
    <div v-if="text=='DBMIN'" class="interpretation">
      <p>函数描述： 对可扩展单元格集合所有数据进行求最小值；</p>
      <p>示例：</p>
      <p>DBMIN(db.salary)，对编码为db的数据集中的字段salary进行最小值计算</p>
    </div>
  </div>
</script>
<script>
  Vue.component('j-function-interpretation', {
    template: '#function-interpretation',
    props: {
      text: {
        type: String,
        required: true,
        default:""
      },
    },
  })
</script>