// Ad system has been completely disabled
// This file is kept for compatibility but no ads will be shown

console.log("Ad system disabled - no promotional content will be displayed");

// Stub functions to prevent errors if other scripts try to call ad functions
window.adManager = {
    showAd: function() {
        console.log("Ad system disabled - showAd() called but ignored");
    },
    hideAd: function() {
        console.log("Ad system disabled - hideAd() called but ignored");
    },
    refetchAd: function() {
        console.log("Ad system disabled - refetchAd() called but ignored");
    },
    showRewardAd: function() {
        console.log("Ad system disabled - showRewardAd() called but ignored");
    },
    registerRewardCallbacks: function() {
        console.log("Ad system disabled - registerRewardCallbacks() called but ignored");
    },
    closeAd: function() {
        console.log("Ad system disabled - closeAd() called but ignored");
    },
    start: function() {
        console.log("Ad system disabled - start() called but ignored");
    },
    useAbsoluteLinks: false,
    classroomGames: false
};

// Stub function for compatibility
window.syncPromoManager = function() {
    console.log("Ad system disabled - syncPromoManager() called but ignored");
};

// Prevent any iframe detection logic from running
try {
    // Disable any parent URL detection
    function unblockedGetParentUrl() {
        return null;
    }

    console.log("Ad system completely disabled - no promotional content will be loaded");
} catch(error) {
    console.log("Ad system disabled - error handling disabled:", error);
}