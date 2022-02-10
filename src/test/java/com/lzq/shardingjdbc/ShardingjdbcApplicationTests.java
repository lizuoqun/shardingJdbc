package com.lzq.shardingjdbc;

import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.lzq.shardingjdbc.entity.Common;
import com.lzq.shardingjdbc.entity.Detail;
import com.lzq.shardingjdbc.entity.User;
import com.lzq.shardingjdbc.mapper.CommonMapper;
import com.lzq.shardingjdbc.mapper.DetailMapper;
import com.lzq.shardingjdbc.mapper.UserMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class ShardingjdbcApplicationTests {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private DetailMapper detailMapper;

    @Autowired
    private CommonMapper commonMapper;

    @Test
    void contextLoads() {
        for (int i = 0; i < 10; i++) {
            User user = new User();
            user.setName("test test" + i);
            user.setUserId(i);
            userMapper.insert(user);
        }
    }

    @Test
    public void cz() {
        Detail detail = new Detail();
        detail.setSex("男");
        detail.setAge("18");
        detailMapper.insert(detail);
    }

    @Test
    public void addCommon() {
        Common common = new Common();
        common.setRemark("123");
        commonMapper.insert(common);
    }

    @Test
    public void updateCommon() {
        Common common = new Common();
        UpdateWrapper<Common> updateWrapper = new UpdateWrapper<>();
        updateWrapper.eq("common_id", 698648211442630657L);
        common.setRemark("this is remark");
        commonMapper.update(common, updateWrapper);
    }

    @Test
    void master() {
        User user = new User();
        user.setId(1234567L);
        user.setName("master");
        user.setUserId(2);
        userMapper.insert(user);
    }

    @Test
    void salveSearch() {
        User user = userMapper.selectById(1234567L);
        System.out.println(user);
    }
}
