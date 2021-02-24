/*
 * Copyright (C) 2021 - Max O'Cull <max.ocull@protonmail.com>
 * All rights reserved.
 *
 * You may use this file under the terms of BSD license as follows:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the author nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

// :%s/new Date()/wallClock.time/gci

import QtQuick 2.1

Item {
    function twoDigits(x) {
        if (x<10) return "0"+x;
        else      return x;
    }

    function prepareContext(ctx) {
        ctx.reset()
        ctx.fillStyle = "white"
        ctx.textAlign = "center"
        ctx.textBaseline = 'middle';
        ctx.shadowColor = Qt.rgba(0, 0, 0, 1)
        ctx.shadowOffsetX = 0
        ctx.shadowOffsetY = 0
        ctx.shadowBlur = parent.height*0.00313*2 // 2 px on 320x320
    }

    //Image {
        //source: "background.jpg"
        //width: 160
        //height: 160
    //}

    //Canvas {
        //id: watchBackground
        //anchors.fill: parent
        //antialiasing: true
        //smooth: true
        //renderTarget: Canvas.FramebufferObject
        //onPaint: {
            //var ctx = getContext("2d")
            //prepareContext(ctx)

            //ctx.fillStyle = Qt.rgba(0.05, 0.05, 0.05, 1)
            //ctx.fillRect(0, 0, parent.width, parent.height)
        //}
    //}

    Canvas {
        z: 10
        id: hourCanvas
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.FramebufferObject

        property var hour: 0

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.textAlign = "left"
            ctx.textBaseline = "left"
            ctx.shadowBlur = parent.height*0.00313*3
            ctx.font = "64 " + height*0.2 + "px Roboto"
            ctx.fillText(twoDigits(hour), width*0.12, height*0.5)
        }
    }

    Canvas {
        z: 11
        id: minuteCanvas
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.FramebufferObject

        property var minute: 0

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.shadowBlur = parent.height*0.00313*2
            ctx.font = "32 " + height*0.2 + "px Roboto"
            ctx.fillText(twoDigits(minute),
                         width*0.5,
                         height*0.5);
        }
    }

    Canvas {
        z: 12
        id: secondCanvas
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.FramebufferObject

        property var second: 0

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.textAlign = "right"
            ctx.textBaseline = "right"
            ctx.shadowBlur = parent.height*0.00313
            ctx.font = "16 " + height*0.2 + "px Roboto"
            ctx.fillText(twoDigits(second),
                         width*0.88,
                         height*0.5);
        }
    }

    Canvas {
        z: 13
        id: dateCanvas
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.FramebufferObject

        property var date: 0

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.textAlign = "center"
            ctx.textBaseline = "right"
            var ctx = getContext("2d")

            ctx.shadowBlur = parent.height*0.00313*2
            ctx.font = "48 " + height*0.1 + "px Roboto"
            ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "yyyy-MM-dd"),
                         width*0.5,
                         height*0.666);
        }
    }

    Canvas {
        z: 1
        id: secondDisplay
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.FramebufferObject

        property var millisecond: 0

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.strokeStyle = Qt.rgba(0.976471, 0.258824, 0.227451, 1) // Vignelli Red; aka PANTONE Warm Red C
            ctx.shadowColor = Qt.rgba(0.976471, 0.258824, 0.227451, 1)
            ctx.lineWidth = parent.height*0.00313*5

            ctx.translate(parent.width/2, parent.height/2)
            ctx.rotate(Math.PI)
            ctx.beginPath()
            ctx.rotate(Math.PI/30*(wallClock.time.getSeconds() * 1000 + wallClock.time.getMilliseconds()) / 1000)
            ctx.moveTo(0, height*0.5)
            ctx.lineTo(0, height*0.4)
            ctx.stroke()
        }
    }

    Canvas {
        z: 2
        id: minuteDisplay
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.FramebufferObject

        property var second: 0

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1)
            ctx.shadowColor = Qt.rgba(1, 1, 1, 0.666)
            ctx.lineWidth = parent.height*0.00313*5

            ctx.translate(parent.width/2, parent.height/2)
            ctx.rotate(Math.PI)
            ctx.beginPath()
            ctx.rotate(Math.PI/30*(wallClock.time.getMinutes() * 60 + wallClock.time.getSeconds()) / 60)
            ctx.moveTo(0, height*0.5)
            ctx.lineTo(0, height*0.4 + height*0.033)
            ctx.stroke()
        }
    }

    Canvas {
        z: 3
        id: hourDisplay
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.FramebufferObject

        property var minute: 0

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1)
            ctx.shadowColor = Qt.rgba(1, 1, 1, 0.666)
            ctx.lineWidth = parent.height*0.00313*5

            ctx.translate(parent.width/2, parent.height/2)
            ctx.rotate(Math.PI)
            ctx.beginPath()
            ctx.rotate(Math.PI/30*(wallClock.time.getHours() * 60 + wallClock.time.getMinutes()) / 60)
            ctx.moveTo(0, height*0.5)
            ctx.lineTo(0, height*0.4 + height*0.066)
            ctx.stroke()
        }
    }

    //Timer {
        //id: timer
        //interval: 100; running: true; repeat: true
    //}

    Connections {
        //target: timer
        //onTriggered: {
        target: wallClock
        onTimeChanged: {
            var hour = wallClock.time.getHours()
            var minute = wallClock.time.getMinutes()
            var second = wallClock.time.getSeconds()
            var millisecond = wallClock.time.getMilliseconds()
            var date = wallClock.time.getDate()

            if(hourCanvas.hour != hour) {
                hourCanvas.hour = hour
                hourCanvas.requestPaint()
            } if(minuteCanvas.minute != minute) {
                minuteCanvas.minute = minute
                minuteCanvas.requestPaint()
            } if(secondCanvas.second != second) {
                secondCanvas.second = second
                secondCanvas.requestPaint()
            } if(dateCanvas.date != date) {
                dateCanvas.date = date
                dateCanvas.requestPaint()
            } if (secondDisplay.millisecond != millisecond) {
                secondDisplay.millisecond = millisecond
                secondDisplay.requestPaint()
            } if (minuteDisplay.second != second) {
                minuteDisplay.second = second
                minuteDisplay.requestPaint()
            } if (hourDisplay.minute != minute) {
                hourDisplay.minute = minute
                hourDisplay.requestPaint()
            }
        }
    }

    Component.onCompleted: {
        var hour = wallClock.time.getHours()
        var minute = wallClock.time.getMinutes()
        var second = wallClock.time.getSeconds()
        var millisecond = wallClock.time.getMilliseconds()
        var date = wallClock.time.getDate()

        hourCanvas.hour = hour
        hourCanvas.requestPaint()
        minuteCanvas.minute = minute
        minuteCanvas.requestPaint()
        secondCanvas.second = second
        secondCanvas.requestPaint()
        dateCanvas.date = date
        dateCanvas.requestPaint()
        secondDisplay.millisecond = millisecond
        secondDisplay.requestPaint()
        minuteDisplay.second = second
        minuteDisplay.requestPaint()
        hourDisplay.minute = minute
        hourDisplay.requestPaint()
    }
}
