const db = db.getSiblingDB("swlws");

// 删除已存在的集合
print("正在删除已存在的集合...");
db.test.drop();

// 插入测试数据
print("正在插入测试数据...");
const result = db.test.insertMany([
  {
    "id": 1,
    "name": "测试数据1",
    "description": "这是第一条测试数据",
    "createTime": new Date(),
    "updateTime": new Date()
  }
]);

// 验证插入结果
const count = db.test.countDocuments();
print("成功插入数据数量：" + count);

if(count > 0) {
  print("插入的数据：");
  db.test.find().forEach(printjson);
} else {
  print("警告：未成功插入数据！");
}