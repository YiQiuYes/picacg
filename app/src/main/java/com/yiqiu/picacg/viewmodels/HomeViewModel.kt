package com.yiqiu.picacg.viewmodels

import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.google.gson.Gson
import com.yiqiu.picacg.apis.RetrofitInstance
import com.yiqiu.picacg.data.repositorys.CampaignRepository
import com.yiqiu.picacg.data.repositorys.ContentRepository
import com.yiqiu.picacg.models.Announcement
import com.yiqiu.picacg.models.Comic
import com.yiqiu.picacg.models.ComicInfo
import com.yiqiu.picacg.models.ErrorBody
import com.yiqiu.picacg.models.PageData
import com.yiqiu.picacg.ui.HomeShowType
import com.yiqiu.picacg.utils.Toast
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class HomeViewModel : ViewModel() {
    private val tag: String = HomeViewModel::class.java.simpleName

    private val handlerError = CoroutineExceptionHandler { _, e ->
        Log.e(tag, "Error Fetch API $e")
    }

    fun closeDetailScreen() {
        _uiState.value = _uiState.value.copy(isDetailOpen = false)
    }

    fun openDetailScreen() {
        _uiState.value = _uiState.value.copy(isDetailOpen = true)
    }

    fun initFinish() {
        _uiState.value = _uiState.value.copy(isInit = true)
    }

    fun getAnnouncements(page: Int) {
        if (_uiState.value.announcements.page == page && _uiState.value.announcements.docs.isNotEmpty()) {
            _uiState.value = _uiState.value.copy(announcementIsEnd = true)
            return
        }

        viewModelScope.launch(handlerError) {
            val res = campaignRepository.getAnnouncements(page = page)
            if (res.isSuccessful) {
                val data = res.body()?.data?.announcements
                if (data == null) {
                    Log.e(tag, "getAnnouncements returned null data")
                    return@launch
                } else if (data.page == _uiState.value.announcements.page) {
                    return@launch
                }

                _uiState.value = _uiState.value.copy(
                    announcements = _uiState.value.announcements.copy(
                        total = data.total,
                        limit = data.limit,
                        page = data.page,
                        pages = data.pages,
                        docs = _uiState.value.announcements.docs + data.docs
                    )
                )
            } else {
                try {
                    val error = Gson().fromJson(res.errorBody()?.string(), ErrorBody::class.java)
                    Log.e(tag, "getAnnouncements failed: ${error.message}")
                    viewModelScope.launch {
                        Toast.showError("getAnnouncements failed: ${error.message}")
                    }
                } catch (e: Exception) {
                    Log.e(tag, "Error parsing error body: ${e.message}")
                    viewModelScope.launch {
                        Toast.showError("Unexpected error occurred during getAnnouncements")
                    }
                }
            }
        }
    }

    fun getRecommendComics() {
        viewModelScope.launch(handlerError) {
            val res = contentRepository.randomComic()

            if (res.isSuccessful) {
                val data = res.body()?.data?.comics ?: emptyList()
                _uiState.value = _uiState.value.copy(
                    recommendComics = data
                )
            } else {
                try {
                    val error = Gson().fromJson(res.errorBody()?.string(), ErrorBody::class.java)
                    Log.e(tag, "getRecommendComics failed: ${error.message}")
                    viewModelScope.launch {
                        Toast.showError("getRecommendComics failed: ${error.message}")
                    }
                } catch (e: Exception) {
                    Log.e(tag, "Error parsing error body: ${e.message}")
                    viewModelScope.launch {
                        Toast.showError("Unexpected error occurred during getRecommendComics")
                    }
                }
            }
        }
    }

    fun getComicInfo() {
        viewModelScope.launch(handlerError) {
            val res =
                contentRepository.comicInfo(_uiState.value.recommendComics[_uiState.value.selectRecommendIndex].id)

            if (res.isSuccessful) {
                val data = res.body()?.data?.comic
                if (data != null) {
                    _uiState.value = _uiState.value.copy(comicInfo = data)
                }
            } else {
                try {
                    val error = Gson().fromJson(res.errorBody()?.string(), ErrorBody::class.java)
                    Log.e(tag, "getComicInfo failed: ${error.message}")
                    viewModelScope.launch {
                        Toast.showError("getComicInfo failed: ${error.message}")
                    }
                } catch (e: Exception) {
                    Log.e(tag, "Error parsing error body: ${e.message}")
                    viewModelScope.launch {
                        Toast.showError("Unexpected error occurred during getComicInfo")
                    }
                }
            }
        }
    }

    fun choiceIndex(showDetailType: HomeShowType, index: Int) {
        when (showDetailType) {
            HomeShowType.ANNOUNCEMENT -> {
                _uiState.value = _uiState.value.copy(
                    showDetailType = HomeShowType.ANNOUNCEMENT,
                    selectAnnouncementIndex = index,
                )
            }

            HomeShowType.RECOMMEND_COMIC -> {
                _uiState.value = _uiState.value.copy(
                    showDetailType = HomeShowType.RECOMMEND_COMIC,
                    selectRecommendIndex = index,
                )
                getComicInfo()
            }
        }
    }

    fun changeShowMore() {
        val showMoreType = if (_uiState.value.showMoreType == HomeShowType.ANNOUNCEMENT) {
            HomeShowType.RECOMMEND_COMIC
        } else {
            HomeShowType.ANNOUNCEMENT
        }

        _uiState.value = _uiState.value.copy(
            showMoreType = showMoreType
        )
    }

    private val campaignRepository by lazy {
        CampaignRepository(RetrofitInstance.campaign)
    }
    private val contentRepository by lazy {
        ContentRepository(RetrofitInstance.content)
    }
    private val _uiState = MutableStateFlow(HomeUIState())
    val uiState: StateFlow<HomeUIState> = _uiState
}

data class HomeUIState(
    val isDetailOpen: Boolean = false,
    val isInit: Boolean = false,
    val announcements: PageData<Announcement> = PageData(
        total = 0, limit = 0, page = 0, pages = 0, docs = emptyList()
    ),
    val comicInfo: ComicInfo? = null,
    val announcementIsEnd: Boolean = false,
    val recommendComics: List<Comic> = emptyList(),
    val showDetailType: HomeShowType = HomeShowType.ANNOUNCEMENT,
    val showMoreType: HomeShowType = HomeShowType.RECOMMEND_COMIC,
    val selectAnnouncementIndex: Int = -1,
    val selectRecommendIndex: Int = -1,
)