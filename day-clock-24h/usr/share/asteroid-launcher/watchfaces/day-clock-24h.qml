/*
 * Copyright (C) 2018 - Timo Könnecke <el-t-mo@arcor.de>
 *               2016 - Sylvia van Os <iamsylvie@openmailbox.org>
 *               2015 - Florent Revest <revestflo@gmail.com>
 *               2012 - Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
 *                      Aleksey Mikhailichenko <a.v.mich@gmail.com>
 *                      Arto Jalkanen <ajalkane@gmail.com>
 * All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * Based on kitt by velox/jgibbon regarding arcs and image embedding.
 * v2, corrected line height problems by seperating the font line-breaks
 * into own text items  for more precise alignment.
 */

import QtQuick 2.1

Item {

    Canvas {
        z: 1
        id: twentyfourhourArc
        anchors.fill: parent
        smooth: true
        renderTarget: Canvas.FramebufferObject
        onPaint: {
            var ctx = getContext("2d")
            var rot =  0.25 * (60 * (wallClock.time.getHours()+6) + wallClock.time.getMinutes())
            ctx.reset()
            ctx.beginPath()
            ctx.lineWidth = parent.width/42
            ctx.fillStyle = Qt.rgba(0, 0, 0, 0.5)
            ctx.arc(parent.width/2, parent.height/2, width, 90*0.01745, rot*0.01745, false);
            ctx.lineTo(parent.width/2, parent.height/2)
            ctx.fill()
        }
    }

    Image {
        z: 2
        id: logoAsteroid
        source: "day-clock-center.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width/3
        height: parent.height/3
    }

    Text {
        z: 3
        id: hourDisplay
        property var offset: height*0.5
        font.pixelSize: parent.height*0.22
        font.family: "Vollkorn"
        font.styleName:"Regular"
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.9
        horizontalAlignment: Text.AlignHCenter
        x: parent.width/14
        y: parent.height/2.5-offset
        text: wallClock.time.toLocaleString(Qt.locale(), "HH")
    }

    Text {
        z: 3
        id: minuteDisplay
        property var offset: height*0.5
        font.pixelSize: parent.height*0.22
        font.family: "Vollkorn"
        font.styleName:"Regular"
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.9
        horizontalAlignment: Text.AlignHCenter
        x: parent.width/14
        y: parent.height/1.65-offset
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }

    Text {
        z: 4
        id: dayDisplay
        property var offset: height*0.5
        font.pixelSize: parent.height*0.20
        font.family: "Vollkorn"
        font.styleName:"Regular"
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.5
        x: parent.width*0.7
        y: parent.height/2.5-offset
        text: (Math.round((((0.25 * (60 * (wallClock.time.getHours()+6) + wallClock.time.getMinutes())-90)/360)*100) * 1) / 1)
    }

    Text {
        z: 4
        id: percentDisplay
        property var offset: height*0.5
        font.pixelSize: parent.height*0.20
        font.family: "Vollkorn"
        font.styleName:"Regular"
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.5
        x: parent.width*0.73
        y: parent.height/1.58-offset
        text: "%"
    }

    Text {
        z: 5
        id: dayofweekDisplay
        font.pixelSize: parent.height*0.10
        font.family: "Vollkorn"
        font.styleName:"Regular"
        lineHeight: parent.height*0.0025
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.7
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height/9
        text: wallClock.time.toLocaleString(Qt.locale(), "dddd")
    }

    Text {
        z: 6
        id: dateDisplay
        font.pixelSize: parent.height*0.1
        font.family: "Vollkorn"
        font.styleName:"Regular"
        lineHeight: parent.height*0.0025
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.8
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height/1.32
        text: wallClock.time.toLocaleString(Qt.locale(), "yyyy MM dd")
    }

    Connections {
        target: wallClock
        onTimeChanged: {
            twentyfourhourArc.requestPaint()
        }
    }

    Component.onCompleted: {
        twentyfourhourArc.requestPaint()
    }
}
