package com.yiqiu.picacg.viewmodels

import android.util.Log
import androidx.datastore.core.DataStore
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavHostController
import com.google.gson.Gson
import com.yiqiu.picacg.apis.RetrofitInstance
import com.yiqiu.picacg.data.dto.AuthDTO
import com.yiqiu.picacg.data.repositorys.AuthRepository
import com.yiqiu.picacg.datastore.UserPreferences
import com.yiqiu.picacg.models.ErrorBody
import com.yiqiu.picacg.ui.navigation.Route
import com.yiqiu.picacg.utils.Store
import com.yiqiu.picacg.utils.Toast
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

@Suppress("UNCHECKED_CAST")
class LoginViewModel: ViewModel() {
    private val tag: String = LoginViewModel::class.java.simpleName

    private val handlerError = CoroutineExceptionHandler { _, e ->
        Log.e(tag, "Error Fetch API $e")
    }

    fun onUsernameChange(text: String) {
        _uiState.value = _uiState.value.copy(username = text)
    }

    private fun onUsernameValid() {
        val username = _uiState.value.username
        val isValid =
            username.matches(Regex("^(\\+\\d{1,3}[- ]?)?1[3-9]\\d{9}$")) || username.matches(Regex("^.+@.+\\\\.[A-Za-z]+$"))
        _uiState.value = _uiState.value.copy(usernameValid = isValid)
    }

    fun onPasswordChange(text: String) {
        _uiState.value = _uiState.value.copy(password = text)
    }

    fun onPasswordValid() {
        val password = _uiState.value.password
        val isValid = password.length >= 6
        _uiState.value = _uiState.value.copy(passwordValid = isValid)
    }

    fun onLoginClick(navController: NavHostController) {
        onUsernameValid()
        onPasswordValid()
        if (_uiState.value.usernameValid && _uiState.value.passwordValid) {
            viewModelScope.launch(handlerError) {
                val res = authRepository.login(
                    AuthDTO.LoginRequest(
                        email = _uiState.value.username, password = _uiState.value.password
                    )
                )

                if (res.isSuccessful) {
                    viewModelScope.launch {
                        Toast.showSuccess("Login successful")
                        Store.userPreferences.updateData { preferences ->
                            preferences.toBuilder()
                                .setToken(res.body()?.data?.token ?: "")
                                .setUserName(uiState.value.username)
                                .setPassWord(uiState.value.password)
                                .setIsLogin(true)
                                .build()
                        }

                        navController.navigate(Route.Main) {
                            popUpTo(navController.graph.startDestinationId) {
                                inclusive = true
                            }
                        }
                    }
                } else {
                    try {
                        val error =
                            Gson().fromJson(res.errorBody()?.string(), ErrorBody::class.java)
                        Log.e(tag, "Login failed: ${error.message}")
                        viewModelScope.launch {
                            Toast.showError("Login failed: ${error.message}")
                        }
                    } catch (e: Exception) {
                        Log.e(tag, "Error parsing error body: ${e.message}")
                        viewModelScope.launch {
                            Toast.showError("Unexpected error occurred during login")
                        }
                    }
                }
            }
        }
    }

    private val authApi by lazy {
        RetrofitInstance.authApi
    }
    private val authRepository by lazy {
        AuthRepository(authApi)
    }
    private val _uiState = MutableStateFlow(LoginUIState())
    val uiState: StateFlow<LoginUIState> = _uiState
}

data class LoginUIState(
    val username: String = "19918400038",
    val usernameValid: Boolean = true,
    val password: String = "19918400038abc1",
    val passwordValid: Boolean = true
)