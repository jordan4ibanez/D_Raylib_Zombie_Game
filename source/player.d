module player;

import raylib;
import std.stdio;
import camera;
import keyboard;

import std.math.trigonometry: cos, sin, atan;


public class Player {

    private float size = 50;
    private Vector2 position;
    private Vector2 speed;

    this(Vector2 position) {
        this.position = position;        
    }

    Vector2 getPosition() {
        return this.position;
    }

    float getX() {
        return this.position.x;
    }

    float getY() {
        return this.position.y;
    }

    float getSize() {
        return this.size;
    }

    void move(GameCamera camera, Keyboard keyboard) {
        Vector2 movement = Vector2(0,0);

        if (keyboard.getForward()) {
            movement.x -= 1;
        }
        if (keyboard.getBack()) {
            movement.x += 1;
        }
        if (keyboard.getRight()) {
            movement.y += 1;
        }
        if (keyboard.getLeft()) {
            movement.y -= 1;
        }


        float rotation = camera.getRotation();
        
        Vector2 rotatedVelocity = Vector2(0,0);


        if (movement.x != 0) {
            rotatedVelocity.x += -sin(DEG2RAD * (rotation * -1.0)) * movement.x;
            rotatedVelocity.y +=  cos(DEG2RAD * (rotation * -1.0)) * movement.x;
        }
        if (movement.y != 0) {
            rotatedVelocity.y += -sin(DEG2RAD * rotation) * movement.y;
            rotatedVelocity.x +=  cos(DEG2RAD * rotation) * movement.y;
        }
        

        rotatedVelocity = Vector2Normalize(rotatedVelocity);        


        this.processSpeed(rotatedVelocity, keyboard.getRun());
        
    }

    private void processSpeed(Vector2 velocity, bool isRunning) {

        float speedLimit = 1;

        if (isRunning) {
            speedLimit = 1.5;
        }

        if (Vector2Length(velocity) == 0 || Vector2Length(this.speed) > speedLimit) {
            Vector2 inverseDirection = Vector2Normalize(this.speed);
            inverseDirection.x *= -1;
            inverseDirection.y *= -1;
            velocity = inverseDirection;
        }


        velocity = Vector2Multiply(velocity, Vector2(0.015, 0.015));

        this.speed = Vector2Add(velocity, this.speed);


        writeln(Vector2Length(this.speed));
        
        if (Vector2Length(this.speed) < 0.0149) {
            this.speed.x = 0;
            this.speed.y = 0;
        } 

        this.position = Vector2Add(this.position, speed);
    }
}