package com.yiqiu.picacg.data.proto

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.core.Serializer
import androidx.datastore.dataStore
import com.yiqiu.picacg.datastore.SettingPreferences
import java.io.InputStream
import java.io.OutputStream

val Context.settingPreferencesStore: DataStore<SettingPreferences> by dataStore(
    fileName = "setting_preferences.pb",
    serializer = SettingPreferencesSerializer
)

object SettingPreferencesSerializer: Serializer<SettingPreferences> {
    override val defaultValue: SettingPreferences
        get() = SettingPreferences.getDefaultInstance()

    override suspend fun readFrom(input: InputStream): SettingPreferences {
        return SettingPreferences.parseFrom(input)
    }

    override suspend fun writeTo(t: SettingPreferences, output: OutputStream) {
        t.writeTo(output)
    }
}