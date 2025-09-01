package com.yiqiu.picacg.data.dto

import com.yiqiu.picacg.models.Init

class ConfigDTO {
    class InitResponse (
        val code: Int,
        val message: String,
        val data: Init
    )
}