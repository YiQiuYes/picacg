package com.yiqiu.picacg.viewmodels

import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.google.gson.Gson
import com.yiqiu.picacg.apis.RetrofitInstance
import com.yiqiu.picacg.data.repositorys.ConfigRepository
import com.yiqiu.picacg.models.ErrorBody
import com.yiqiu.picacg.utils.Store
import com.yiqiu.picacg.utils.Toast
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.launch

class AppViewModel : ViewModel() {
    private val tag: String = AppViewModel::class.java.simpleName

    private val handlerError = CoroutineExceptionHandler { _, e ->
        Log.e(tag, "Error Fetch API $e")
    }

    fun getInitConfig() {
        viewModelScope.launch(handlerError) {
            val res = contentRepository.init()

            if (res.isSuccessful) {
                val data = res.body()?.data

                if (data == null) {
                    Log.e(tag, "getInitConfig returned null data")
                    return@launch
                }

                Store.settingPreferences.updateData { preferences ->
                    preferences.toBuilder()
                        .setImageServer(data.imageServer)
                        .build()
                }
            } else {
                try {
                    val error =
                        Gson().fromJson(res.errorBody()?.string(), ErrorBody::class.java)
                    Log.e(tag, "getInitConfig failed: ${error.message}")
                    viewModelScope.launch {
                        Toast.showError("getInitConfig failed: ${error.message}")
                    }
                } catch (e: Exception) {
                    Log.e(tag, "Error parsing error body: ${e.message}")
                    viewModelScope.launch {
                        Toast.showError("Unexpected error occurred during getInitConfig")
                    }
                }
            }
        }
    }

    private val contentRepository by lazy {
        ConfigRepository(RetrofitInstance.config)
    }
}