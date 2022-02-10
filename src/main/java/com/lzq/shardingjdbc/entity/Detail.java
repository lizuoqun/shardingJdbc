package com.lzq.shardingjdbc.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * @author lizuoqun
 * @version 1.0
 * @date 2022-02-10 21:12
 */
@Data
@TableName(value = "user_detail")
public class Detail {
    private Long userId;
    private String age;
    private String sex;
}
