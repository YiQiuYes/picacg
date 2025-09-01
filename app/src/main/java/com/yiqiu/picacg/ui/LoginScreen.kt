package com.yiqiu.picacg.ui

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.sizeIn
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavHostController
import androidx.window.layout.DisplayFeature
import com.airbnb.lottie.compose.LottieAnimation
import com.airbnb.lottie.compose.LottieCompositionSpec
import com.airbnb.lottie.compose.LottieConstants
import com.airbnb.lottie.compose.rememberLottieComposition
import com.google.accompanist.adaptive.HorizontalTwoPaneStrategy
import com.google.accompanist.adaptive.TwoPane
import com.yiqiu.picacg.R
import com.yiqiu.picacg.ui.utils.PicacgContentType
import com.yiqiu.picacg.viewmodels.LoginUIState
import com.yiqiu.picacg.viewmodels.LoginViewModel

@Composable
fun LoginScreen(
    contentType: PicacgContentType,
    displayFeatures: List<DisplayFeature>,
    navController: NavHostController
) {
    val loginViewModel: LoginViewModel = viewModel()
    val uiState by loginViewModel.uiState.collectAsStateWithLifecycle()

    if (contentType == PicacgContentType.DUAL_PANE) {
        TwoPane(
            first = {
                WelcomeTip()
            },
            second = {
                LoginForm(
                    uiState = uiState,
                    onUsernameChange = { loginViewModel.onUsernameChange(it) },
                    onPasswordChange = { loginViewModel.onPasswordChange(it) },
                    onLoginClick = { loginViewModel.onLoginClick(navController) }
                )
            },
            strategy = HorizontalTwoPaneStrategy(splitFraction = 0.5f, gapWidth = 16.dp),
            displayFeatures = displayFeatures,
        )
    } else {
        SinglePaneContent(
            uiState = uiState,
            onUsernameChange = { loginViewModel.onUsernameChange(it) },
            onPasswordChange = { loginViewModel.onPasswordChange(it) },
            onLoginClick = { loginViewModel.onLoginClick(navController) }
        )
    }
}

@Composable
private fun WelcomeTip() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState()),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            stringResource(R.string.welcome_tip),
            modifier = Modifier
                .fillMaxWidth()
                .padding(start = 20.dp),
            color = MaterialTheme.colorScheme.primary,
            fontSize = 32.sp,
            textAlign = TextAlign.Center,
            fontWeight = FontWeight.Bold
        )

        val composition by rememberLottieComposition(LottieCompositionSpec.Asset("lotties/login.lottie"))
        LottieAnimation(
            modifier = Modifier.height(250.dp),
            alignment = Alignment.Center,
            composition = composition,
            iterations = LottieConstants.IterateForever
        )
    }
}

@Composable
private fun LoginForm(
    uiState: LoginUIState,
    onUsernameChange: (String) -> Unit,
    onPasswordChange: (String) -> Unit,
    onLoginClick: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxHeight()
            .width(500.dp)
            .verticalScroll(rememberScrollState()),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        ElevatedCard(
            modifier = Modifier
                .fillMaxWidth()
                .padding(start = 20.dp, end = 40.dp, top = 55.dp)
        ) {
            Text(
                stringResource(R.string.app_name).replaceFirstChar {
                    if (it.isLowerCase()) it.titlecase() else it.toString()
                },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 50.dp),
                color = MaterialTheme.colorScheme.primary,
                fontSize = 32.sp,
                textAlign = TextAlign.Center,
                fontWeight = FontWeight.Bold
            )

            OutlinedTextField(
                value = uiState.username,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(start = 30.dp, end = 30.dp, bottom = 15.dp, top = 40.dp),
                shape = RoundedCornerShape(12.dp),
                label = {
                    Text(stringResource(R.string.username))
                },
                isError = !uiState.usernameValid,
                supportingText = {
                    if (!uiState.usernameValid) {
                        Text(stringResource(R.string.username_valid))
                    }
                },
                onValueChange = onUsernameChange
            )

            OutlinedTextField(
                value = uiState.password,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(start = 30.dp, end = 20.dp),
                shape = RoundedCornerShape(12.dp),
                label = {
                    Text(stringResource(R.string.password))
                },
                visualTransformation = PasswordVisualTransformation(),
                isError = !uiState.passwordValid,
                supportingText = {
                    if (!uiState.passwordValid) {
                        Text(stringResource(R.string.password_valid))
                    }
                },
                onValueChange = onPasswordChange
            )

            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(end = 30.dp, top = 10.dp),
                horizontalArrangement = Arrangement.End
            ) {
                TextButton(
                    onClick = {}) {
                    Text(stringResource(R.string.forgot_password))
                }
            }

            Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.Center) {
                Button(
                    modifier = Modifier
                        .padding(top = 15.dp, bottom = 25.dp)
                        .sizeIn(minHeight = 50.dp, minWidth = 150.dp),
                    onClick = onLoginClick
                ) {
                    Text(
                        stringResource(R.string.login), fontSize = 18.sp
                    )
                }
            }
        }

        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(end = 30.dp, start = 30.dp, top = 30.dp),
            horizontalArrangement = Arrangement.Center,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text("Don't have an account?")

            TextButton(
                onClick = { }, contentPadding = PaddingValues(horizontal = 5.dp)
            ) {
                Text("Register")
            }
        }
    }
}

@Composable
private fun SinglePaneContent(
    uiState: LoginUIState,
    onUsernameChange: (String) -> Unit,
    onPasswordChange: (String) -> Unit,
    onLoginClick: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .verticalScroll(rememberScrollState()),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        ElevatedCard(
            modifier = Modifier
                .width(500.dp)
                .padding(start = 30.dp, end = 30.dp, top = 55.dp)
        ) {
            Text(
                stringResource(R.string.app_name).replaceFirstChar {
                    if (it.isLowerCase()) it.titlecase() else it.toString()
                },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 20.dp),
                color = MaterialTheme.colorScheme.primary,
                fontSize = 32.sp,
                textAlign = TextAlign.Center,
                fontWeight = FontWeight.Bold
            )

            val composition by rememberLottieComposition(LottieCompositionSpec.Asset("lotties/login.lottie"))
            LottieAnimation(
                modifier = Modifier
                    .height(220.dp)
                    .fillMaxWidth()
                    .padding(end = 20.dp),
                composition = composition,
                iterations = LottieConstants.IterateForever
            )

            OutlinedTextField(
                value = uiState.username,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(start = 30.dp, end = 30.dp, bottom = 15.dp),
                shape = RoundedCornerShape(12.dp),
                label = {
                    Text(stringResource(R.string.username))
                },
                isError = !uiState.usernameValid,
                supportingText = {
                    if (!uiState.usernameValid) {
                        Text(stringResource(R.string.username_valid))
                    }
                },
                onValueChange = onUsernameChange
            )

            OutlinedTextField(
                value = uiState.password,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(start = 30.dp, end = 20.dp),
                shape = RoundedCornerShape(12.dp),
                label = {
                    Text(stringResource(R.string.password))
                },
                visualTransformation = PasswordVisualTransformation(),
                isError = !uiState.passwordValid,
                supportingText = {
                    if (!uiState.passwordValid) {
                        Text(stringResource(R.string.password_valid))
                    }
                },
                onValueChange = onPasswordChange
            )

            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(end = 30.dp, top = 10.dp),
                horizontalArrangement = Arrangement.End
            ) {
                TextButton(
                    onClick = {}) {
                    Text(stringResource(R.string.forgot_password))
                }
            }

            Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.Center) {
                Button(
                    modifier = Modifier
                        .padding(top = 15.dp, bottom = 25.dp)
                        .sizeIn(minHeight = 50.dp, minWidth = 150.dp),
                    onClick = onLoginClick
                ) {
                    Text(
                        stringResource(R.string.login), fontSize = 18.sp
                    )
                }
            }
        }

        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(end = 30.dp, start = 30.dp, top = 30.dp),
            horizontalArrangement = Arrangement.Center,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(stringResource(R.string.no_account_tip), fontSize = 16.sp)

            TextButton(
                onClick = { }, contentPadding = PaddingValues(horizontal = 5.dp)
            ) {
                Text(stringResource(R.string.register), fontSize = 16.sp)
            }
        }
    }
}