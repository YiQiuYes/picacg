package com.yiqiu.picacg.utils

import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Snackbar
import androidx.compose.material3.SnackbarData
import androidx.compose.material3.SnackbarHostState
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp

enum class ToastType {
    ERROR, SUCCESS, INFO
}

object Toast {
    @JvmStatic
    var toastType: ToastType = ToastType.INFO

    @JvmStatic
    lateinit var snackbarHostState: SnackbarHostState

    @JvmStatic
    fun init(snackbarHostState: SnackbarHostState) {
        this.snackbarHostState = snackbarHostState
    }

    @JvmStatic
    suspend fun show(message: String, type: ToastType = ToastType.INFO) {
        when (type) {
            ToastType.ERROR -> showError(message = message)
            ToastType.SUCCESS -> showSuccess(message = message)
            ToastType.INFO -> showInfo(message = message)
        }
    }

    @JvmStatic
    suspend fun showError(message: String) {
        toastType = ToastType.ERROR
        snackbarHostState.showSnackbar(message, withDismissAction = true)
    }

    @JvmStatic
    suspend fun showSuccess(message: String) {
        toastType = ToastType.SUCCESS
        snackbarHostState.showSnackbar(message, withDismissAction = true)
    }

    suspend fun showInfo(message: String) {
        toastType = ToastType.INFO
        snackbarHostState.showSnackbar(message, withDismissAction = true)
    }
}

@Composable
fun SnackbarComponent(snackbarData: SnackbarData) {
    when (Toast.toastType) {
        ToastType.INFO -> Snackbar(
            snackbarData = snackbarData,
            containerColor = MaterialTheme.colorScheme.primaryContainer,
            contentColor = MaterialTheme.colorScheme.onPrimaryContainer,
            dismissActionContentColor = MaterialTheme.colorScheme.onPrimaryContainer,
            shape = RoundedCornerShape(12.dp),
        )
        ToastType.SUCCESS -> Snackbar(
            snackbarData = snackbarData,
            containerColor = Color(0xFFA3E8B2),
            contentColor = Color(0xFF0A8326),
            dismissActionContentColor = Color(0xFF0A8326),
            shape = RoundedCornerShape(12.dp),
        )
        ToastType.ERROR -> Snackbar(
            snackbarData = snackbarData,
            containerColor = MaterialTheme.colorScheme.errorContainer,
            contentColor = MaterialTheme.colorScheme.onErrorContainer,
            dismissActionContentColor = MaterialTheme.colorScheme.onErrorContainer,
            shape = RoundedCornerShape(12.dp),
        )
    }
}