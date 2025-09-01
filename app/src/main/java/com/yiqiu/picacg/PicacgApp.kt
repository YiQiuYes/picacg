package com.yiqiu.picacg

import android.annotation.SuppressLint
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.adaptive.navigationsuite.NavigationSuiteType
import androidx.compose.material3.windowsizeclass.WindowSizeClass
import androidx.compose.material3.windowsizeclass.WindowWidthSizeClass
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.platform.LocalContext
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import androidx.window.layout.DisplayFeature
import androidx.window.layout.FoldingFeature
import com.yiqiu.picacg.data.proto.settingPreferencesStore
import com.yiqiu.picacg.data.proto.userPreferencesStore
import com.yiqiu.picacg.datastore.UserPreferences
import com.yiqiu.picacg.ui.HomeScreen
import com.yiqiu.picacg.ui.LoginScreen
import com.yiqiu.picacg.ui.navigation.PicacgNavigationActions
import com.yiqiu.picacg.ui.navigation.PicacgNavigationWrapper
import com.yiqiu.picacg.ui.navigation.RequireLogin
import com.yiqiu.picacg.ui.navigation.Route
import com.yiqiu.picacg.ui.utils.DevicePosture
import com.yiqiu.picacg.ui.utils.PicacgContentType
import com.yiqiu.picacg.ui.utils.PicacgNavigationType
import com.yiqiu.picacg.ui.utils.isBookPosture
import com.yiqiu.picacg.ui.utils.isSeparating
import com.yiqiu.picacg.utils.SnackbarComponent
import com.yiqiu.picacg.utils.Store
import com.yiqiu.picacg.utils.Toast
import com.yiqiu.picacg.viewmodels.AppViewModel
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking

private fun NavigationSuiteType.toPicacgNavType() = when (this) {
    NavigationSuiteType.NavigationBar -> PicacgNavigationType.BOTTOM_NAVIGATION
    NavigationSuiteType.NavigationRail -> PicacgNavigationType.NAVIGATION_RAIL
    NavigationSuiteType.NavigationDrawer -> PicacgNavigationType.PERMANENT_NAVIGATION_DRAWER
    else -> PicacgNavigationType.BOTTOM_NAVIGATION
}

@SuppressLint("UnusedMaterial3ScaffoldPaddingParameter")
@Composable
fun PicacgApp(
    windowSize: WindowSizeClass,
    displayFeatures: List<DisplayFeature>
) {
    val foldingFeature = displayFeatures.filterIsInstance<FoldingFeature>().firstOrNull()

    val foldingDevicePosture = when {
        isBookPosture(foldingFeature) ->
            DevicePosture.BookPosture(foldingFeature.bounds)

        isSeparating(foldingFeature) ->
            DevicePosture.Separating(foldingFeature.bounds, foldingFeature.orientation)

        else -> DevicePosture.NormalPosture
    }

    val contentType = when (windowSize.widthSizeClass) {
        WindowWidthSizeClass.Compact -> PicacgContentType.SINGLE_PANE
        WindowWidthSizeClass.Medium -> if (foldingDevicePosture != DevicePosture.NormalPosture) {
            PicacgContentType.DUAL_PANE
        } else {
            PicacgContentType.SINGLE_PANE
        }

        WindowWidthSizeClass.Expanded -> PicacgContentType.DUAL_PANE
        else -> PicacgContentType.SINGLE_PANE
    }

    val navController = rememberNavController()
    val context = LocalContext.current
    val snackbarHostState = remember { SnackbarHostState() }
    Toast.init(snackbarHostState)
    Store.init(
        userPreferences = context.userPreferencesStore,
        settingPreferences = context.settingPreferencesStore
    )
    val appViewModel: AppViewModel = viewModel()
    appViewModel.getInitConfig()

    Scaffold(snackbarHost = {
        SnackbarHost(
            hostState = snackbarHostState,
            snackbar = { snackbarData ->
                SnackbarComponent(snackbarData)
            })
    }) {
        NavHost(
            navController = navController,
            startDestination = Route.Main,
        ) {
            composable<Route.Main> {
                val user =
                    Store.userPreferences.data.collectAsState(initial = UserPreferences.getDefaultInstance())

                val isLogin = runBlocking {
                    Store.userPreferences.data.first().isLogin
                }

                RequireLogin(
                    isLoggedIn = user.value.isLogin || isLogin,
                    navController = navController
                ) {
                    PicacgMainNavHost(
                        contentType = contentType,
                        displayFeatures = displayFeatures
                    )
                }
            }

            composable<Route.Login> {
                LoginScreen(
                    contentType = contentType,
                    displayFeatures = displayFeatures,
                    navController = navController
                )
            }
        }
    }
}

@Composable
fun PicacgMainNavHost(
    contentType: PicacgContentType,
    displayFeatures: List<DisplayFeature>
) {
    val navController = rememberNavController()
    val navigationActions = remember(navController) {
        PicacgNavigationActions(navController)
    }
    val navBackStackEntry by navController.currentBackStackEntryAsState()
    val currentDestination = navBackStackEntry?.destination

    PicacgNavigationWrapper(
        currentDestination = currentDestination,
        navigateToTopLevelDestination = navigationActions::navigateTo
    ) {
        NavHost(
            navController = navController,
            startDestination = Route.Home
        ) {
            composable<Route.Home> {
                HomeScreen(
                    contentType = contentType,
                    navigationType = navSuiteType.toPicacgNavType(),
                    displayFeatures = displayFeatures
                )
            }
            composable<Route.Category> {
                Text("Category")
            }
            composable<Route.Game> {
                Text("Game")
            }
            composable<Route.Person> {
                Text("Person")
            }
        }
    }
}