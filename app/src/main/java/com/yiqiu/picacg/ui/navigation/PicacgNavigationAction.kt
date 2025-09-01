package com.yiqiu.picacg.ui.navigation

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Category
import androidx.compose.material.icons.outlined.Games
import androidx.compose.material.icons.outlined.Home
import androidx.compose.material.icons.outlined.Person
import androidx.compose.material.icons.rounded.Category
import androidx.compose.material.icons.rounded.Games
import androidx.compose.material.icons.rounded.Home
import androidx.compose.material.icons.rounded.Person
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.NavHostController
import com.yiqiu.picacg.R
import kotlinx.serialization.Serializable

sealed interface Route {
    @Serializable
    data object Login : Route

    @Serializable
    data object Main : Route

    @Serializable
    data object Home : Route

    @Serializable
    data object Category : Route

    @Serializable
    data object Game : Route

    @Serializable
    data object Person : Route
}

data class PicacgTopLevelDestination(
    val route: Route,
    val selectedIcon: ImageVector,
    val unselectedIcon: ImageVector,
    val iconTextId: Int
)

@Composable
fun RequireLogin(
    isLoggedIn: Boolean,
    navController: NavHostController,
    content: @Composable () -> Unit
) {
    LaunchedEffect(isLoggedIn) {
        if (!isLoggedIn) {
            navController.navigate(Route.Login) {
                popUpTo(navController.graph.startDestinationId) {
                    inclusive = true
                }
            }
        }
    }

    if (isLoggedIn) {
        content()
    }
}

class PicacgNavigationActions(private val navController: NavHostController) {
    fun navigateTo(destination: PicacgTopLevelDestination) {
        navController.navigate(destination.route) {
            popUpTo(navController.graph.findStartDestination().id) {
                saveState = true
            }

            launchSingleTop = true
            restoreState = true
        }
    }
}

val TOP_LEVEL_DESTINATIONS = listOf(
    PicacgTopLevelDestination(
        route = Route.Home,
        selectedIcon = Icons.Rounded.Home,
        unselectedIcon = Icons.Outlined.Home,
        iconTextId = R.string.tab_home,
    ),
    PicacgTopLevelDestination(
        route = Route.Category,
        selectedIcon = Icons.Rounded.Category,
        unselectedIcon = Icons.Outlined.Category,
        iconTextId = R.string.tab_category,
    ),
    PicacgTopLevelDestination(
        route = Route.Game,
        selectedIcon = Icons.Rounded.Games,
        unselectedIcon = Icons.Outlined.Games,
        iconTextId = R.string.tab_game,
    ),
    PicacgTopLevelDestination(
        route = Route.Person,
        selectedIcon = Icons.Rounded.Person,
        unselectedIcon = Icons.Outlined.Person,
        iconTextId = R.string.tab_person,
    )
)