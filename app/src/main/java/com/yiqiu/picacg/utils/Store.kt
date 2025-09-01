package com.yiqiu.picacg.utils

import androidx.datastore.core.DataStore
import com.yiqiu.picacg.datastore.SettingPreferences
import com.yiqiu.picacg.datastore.UserPreferences

object Store {
    lateinit var userPreferences: DataStore<UserPreferences>

    lateinit var settingPreferences: DataStore<SettingPreferences>

    fun init(
        userPreferences: DataStore<UserPreferences>,
        settingPreferences: DataStore<SettingPreferences>
    ) {
        this.userPreferences = userPreferences
        this.settingPreferences = settingPreferences
    }
}