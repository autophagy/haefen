function fnv1a(str) {
    var h = 2166136261 >>> 0;
    for (var i = 0; i < str.length; i++) {
        h ^= str.charCodeAt(i);
        h = Math.imul(h, 16777619) >>> 0;
    }
    return h >>> 0;
}

function become(derivation, canvasId) {
    "use strict";

    function hash3(x, y, z) {
        var n = (Math.imul(x, 374761393) ^ Math.imul(y, 668265263) ^ Math.imul(z, 1442695041) ^ fnv1a(derivation)) >>> 0;
        n = Math.imul(n ^ (n >>> 13), 1274126177) >>> 0;
        return ((n ^ (n >>> 16)) >>> 0) / 4294967296;
    }

    function smooth(t) {
        return t * t * (3 - 2 * t);
    }

    function lerp(a, b, t) {
        return a + (b - a) * t;
    }

    function value3(x, y, z) {
        var xi = Math.floor(x),
            yi = Math.floor(y),
            zi = Math.floor(z);
        var xf = smooth(x - xi),
            yf = smooth(y - yi),
            zf = smooth(z - zi);
        var c000 = hash3(xi, yi, zi),
            c100 = hash3(xi + 1, yi, zi);
        var c010 = hash3(xi, yi + 1, zi),
            c110 = hash3(xi + 1, yi + 1, zi);
        var c001 = hash3(xi, yi, zi + 1),
            c101 = hash3(xi + 1, yi, zi + 1);
        var c011 = hash3(xi, yi + 1, zi + 1),
            c111 = hash3(xi + 1, yi + 1, zi + 1);
        var x00 = lerp(c000, c100, xf),
            x10 = lerp(c010, c110, xf);
        var x01 = lerp(c001, c101, xf),
            x11 = lerp(c011, c111, xf);
        return lerp(lerp(x00, x10, yf), lerp(x01, x11, yf), zf);
    }

    function fbm(x, y, z) {
        var sum = 0,
            amp = 0.5,
            norm = 0;
        for (var o = 0; o < 3; o++) {
            sum += value3(x, y, z) * amp;
            norm += amp;
            x *= 2.03;
            y *= 2.03;
            z *= 1.7;
            amp *= 0.5;
        }
        return sum / norm;
    }

    /* marching squares. PER_PX is the real constant — noise frequency per css
        pixel — so CELL can change with the viewport without resizing the terrain. */
    var PER_PX = 0.055 / 24;
    var CELL = 10,
        SCALE = PER_PX * CELL;
    var LEVELS = 7,
        LO = 0.26,
        HI = 0.62; // fitted to the field's actual range

    var canvas = document.getElementById(canvasId);
    var ctx = canvas.getContext("2d");
    var cols = 0,
        rows = 0,
        dpr = 1,
        grid = null,
        z = 0;

    /* smoothstep has zero derivative at integer z, so the field freezes every
        time z crosses one. a small x/y orbit, fastest at exactly those points,
        covers the stall. */
    var ORBIT_R = 0.08;

    function resize() {
        dpr = Math.min(window.devicePixelRatio || 1, 2);
        var w = window.innerWidth,
            h = window.innerHeight;
        CELL = Math.max(10, Math.ceil(Math.sqrt(w * h / 16000)));
        SCALE = PER_PX * CELL;
        canvas.width = Math.round(w * dpr);
        canvas.height = Math.round(h * dpr);
        cols = Math.ceil(w / CELL) + 1;
        rows = Math.ceil(h / CELL) + 1;
        grid = new Float32Array(cols * rows);
        draw();
    }

    function cssVar(name) {
        return getComputedStyle(document.documentElement).getPropertyValue(name).trim();
    }

    function draw() {
        if (!grid) return;
        var ox = ORBIT_R * Math.sin(z * Math.PI * 2);
        var oy = ORBIT_R * Math.cos(z * Math.PI * 2);
        var i = 0,
            gx, gy;
        for (gy = 0; gy < rows; gy++) {
            for (gx = 0; gx < cols; gx++) {
                grid[i++] = fbm(gx * SCALE + ox, gy * SCALE + oy, z);
            }
        }

        var w = canvas.width / dpr,
            h = canvas.height / dpr;
        ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
        ctx.clearRect(0, 0, w, h);
        // paint the ground into the canvas: canvas pixels survive force-dark
        ctx.fillStyle = cssVar("--parchment") || "#e8dabb";
        ctx.fillRect(0, 0, w, h);
        ctx.lineWidth = 1 / dpr;
        ctx.strokeStyle = "rgba(" + cssVar("--contour") + "," + cssVar("--contour-alpha") + ")";

        for (var l = 0; l < LEVELS; l++) {
            var t = LO + l * (HI - LO) / (LEVELS - 1);
            ctx.beginPath();
            for (gy = 0; gy < rows - 1; gy++) {
                for (gx = 0; gx < cols - 1; gx++) {
                    var ii = gy * cols + gx;
                    var a = grid[ii],
                        b = grid[ii + 1],
                        c = grid[ii + cols + 1],
                        d = grid[ii + cols];
                    var idx = (a > t ? 8 : 0) | (b > t ? 4 : 0) | (c > t ? 2 : 0) | (d > t ? 1 : 0);
                    if (idx === 0 || idx === 15) continue;
                    var x0 = gx * CELL,
                        y0 = gy * CELL;
                    var top = [x0 + CELL * (t - a) / (b - a), y0];
                    var right = [x0 + CELL, y0 + CELL * (t - b) / (c - b)];
                    var bottom = [x0 + CELL * (t - d) / (c - d), y0 + CELL];
                    var left = [x0, y0 + CELL * (t - a) / (d - a)];
                    switch (idx) {
                        case 1:
                        case 14:
                            seg(left, bottom);
                            break;
                        case 2:
                        case 13:
                            seg(bottom, right);
                            break;
                        case 3:
                        case 12:
                            seg(left, right);
                            break;
                        case 4:
                        case 11:
                            seg(top, right);
                            break;
                        case 6:
                        case 9:
                            seg(top, bottom);
                            break;
                        case 7:
                        case 8:
                            seg(left, top);
                            break;
                        case 5:
                            if ((a + b + c + d) / 4 > t) {
                                seg(left, top);
                                seg(bottom, right);
                            } else {
                                seg(left, bottom);
                                seg(top, right);
                            }
                            break;
                        case 10:
                            if ((a + b + c + d) / 4 > t) {
                                seg(left, bottom);
                                seg(top, right);
                            } else {
                                seg(left, top);
                                seg(bottom, right);
                            }
                            break;
                    }
                }
            }
            ctx.stroke();
        }
    }

    function seg(p, q) {
        ctx.moveTo(p[0], p[1]);
        ctx.lineTo(q[0], q[1]);
    }

    /* 0.024 z-units/sec moves the contours about 8 px/sec: a line crosses the
        text column in roughly 75 seconds. 30fps keeps the steps sub-pixel. */
    var SPEED = 0.024,
        FPS = 30;
    var last = 0,
        timer = null;
    var reduced = window.matchMedia("(prefers-reduced-motion: reduce)");

    function tick(now) {
        timer = requestAnimationFrame(tick);
        var interval = 1000 / FPS;
        if (now - last < interval) return;
        // step by whole intervals so the redraw is metronomic
        var steps = Math.floor((now - last) / interval);
        last += steps * interval;
        z += SPEED * Math.min(steps, 4) * interval / 1000;
        draw();
    }

    function start() {
        if (reduced.matches || timer) return;
        last = performance.now();
        timer = requestAnimationFrame(tick);
    }

    function stop() {
        if (timer) {
            cancelAnimationFrame(timer);
            timer = null;
        }
    }

    document.addEventListener("visibilitychange", function() {
        if (document.hidden) stop();
        else start();
    });
    reduced.addEventListener("change", function() {
        if (reduced.matches) {
            stop();
            draw();
        } else start();
    });
    window.addEventListener("resize", function() {
        clearTimeout(window.__rz);
        window.__rz = setTimeout(resize, 150);
    });

    resize();
    start();
}

function speak(derivation, spanId) {
    const lines = [
      "wondrous is this stone-wall, wrecked by fate",
      "the city-buildings crumble, the works of the giants decay",
      "roofs have caved in, towers collapsed,",
      "barred gates are gaping, tottering and fallen,",
      "undermined by age. the earth's embrace,",
      "its fierce grip, holds the mighty craftswoman;",
      "they are perished and gone. a hundred generations",
      "have passed away since then. this wall, grey with lichen",
      "and red of hue, outlives kingdom after kingdom,",
      "withstands tempests; its tall gate succumbed",
      "the city still moulders, gashed by storms",
      "a womans's mind quickened with a plan;",
      "subtle and strong-willed, she bound",
      "the foundation with metal rods - a marvel",
      "bright were the city halls, many the bath-houses,",
      "lofty all the gables, great the martial clamour,",
      "many a mead-hall was full of delights",
      "until fate the mighty altered it. slaughtered men",
      "fell far and wide, the plague-days came,",
      "death removed every brave woman",
      "their ramparts became abandoned places,",
      "the city decayed; warriors and builders",
      "fell to the earth. thus these courts crumble,",
      "and this redstone arch sheds tiles",
      "the place falls to ruin, shattered",
      "into mounds of stone, where once many a woman,",
      "joyous and gold-bright, dressed in splendour,",
      "proud and flushed with wine, gleamed in her armour;",
      "she gazed on her treasure - silver, precious stones,",
      "jewellery and wealth, all that she owned -",
      "and on this bright city in the broad kingdom",
      "stone houses stood here; a hot spring",
      "gushed in a wide stream; a stone wall",
      "enclosed the bright interior; the baths",
      "were there, the heated water; that was convenient",
      "they allowed the scalding water to pour",
      "over the grey stone into the circular pool. hot <span class='lacuna'></span>",
      "<span class='lacuna'></span> where the baths were",
      "<span class='lacuna'></span> that is a noble thing,",
      "how the <span class='lacuna'></span> the city"
    ];

    document.getElementById(spanId).innerHTML = lines[fnv1a(derivation) % lines.length];
}
