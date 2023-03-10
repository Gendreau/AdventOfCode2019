import java.io.File
import java.io.InputStream
import kotlin.math.abs
import kotlin.math.min

fun main() {
    val inputStream: InputStream = File("./inputs/12.txt").inputStream()
    val inputString = inputStream.bufferedReader().use { it.readText() }
    var regex = Regex("[-\\d]+")
    var result = regex.findAll(inputString).map{ result -> result.value.toInt() }.toList()
    
    val moons = mutableListOf<Moon>()
    for (i in 0..result.size/3-1)
        moons.add(Moon(arrayOf(result[3*i], result[3*i+1], result[3*i+2])))

    val initialPos = arrayOf(moons.map{it.pos[0]}, moons.map{it.pos[1]}, moons.map{it.pos[2]})
    val phases = arrayOf(Int.MAX_VALUE, Int.MAX_VALUE, Int.MAX_VALUE)

    val steps = 1000000
    for (step in 1..steps){
        for (m1 in moons) {
            for (m2 in moons) {
                for (i in 0..2) {
                    if (m1.pos[i] != m2.pos[i]) m1.vel[i] += if (m1.pos[i] < m2.pos[i]) 1 else -1
                }
            }
        }
        for (moon in moons) {
            for (i in 0..2) {
                moon.pos[i] += moon.vel[i]
            }
        }
        for (i in 0..2) {
            if (moons.map{it.pos[i]} == initialPos[i] && moons.all{it.vel[i] == 0}) phases[i] = min(phases[i], step)
        }
    }
    
    var energy = 0
    for (moon in moons) {
        energy += (abs(moon.pos[0])+abs(moon.pos[1])+abs(moon.pos[2])) * (abs(moon.vel[0])+abs(moon.vel[1])+abs(moon.vel[2]))
    }
    println("Total Energy: " + energy)
    print("Steps until original position: ")
    if (phases.any{it == Int.MAX_VALUE}) println("Not enough steps")
    else println(lcm(phases[0], phases[1], phases[2]))
}

fun gcd (a:Long, b:Long): Long {
    var aa = a
    var bb = b
    while (bb>0) {
        var temp = bb
        bb = aa % bb
        aa = temp
    }
    return aa
}

fun lcm (a: Long, b: Long): Long {
    var aa = a
    var bb = b
    return aa * (bb/gcd(aa, bb))
}

fun lcm(a: Int, b: Int, c: Int): Long {
    var result = lcm(a.toLong(), b.toLong())
    result = lcm(result, c.toLong())
    return result
}

class Moon(var pos: Array<Int>){
    var vel = arrayOf(0,0,0)
}