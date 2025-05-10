const db = db.getSiblingDB('swlws');
const collections = '${COLLECTION_LIST}'.split(',');

print('准备删除以下集合：', collections);

collections.forEach(collection => {
  try {
    print('正在删除集合：' + collection);
    db[collection].drop();
    print('成功删除集合：' + collection);
  } catch (error) {
    print('删除集合失败：' + collection + '，错误：' + error.message);
  }
});

print('所有集合删除操作完成！');