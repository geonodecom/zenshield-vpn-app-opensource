package com.zenshield.vpn.ktx

import kotlin.coroutines.Continuation

fun <T> Continuation<T>.tryResumeWithException(exception: Throwable) {
    try {
        resumeWith(Result.failure(exception))
    } catch (_: IllegalStateException) {
    }
}
