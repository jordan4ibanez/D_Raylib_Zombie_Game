module game.player;

import raylib;
import std.stdio;

import engine.world;
import engine.keyboard;
import engine.camera;

import game.game;

/*
torso:
0 - stand
1 - walk
2 - run


todo this index - aim

legs:
0 - stand
1 - walk
2 - run

head:
90 is the 0 so subtract by 90 or something
0 to 180 : pitch

0 - stand pitch
1 - stand to crouch animation
2 - crouch pitch

*/

public class Player {

    private Game game;

    private Entity entity;

    private immutable float eyeHeight = 0.5;
    private immutable float modelYAdjust = 0.075;

    private immutable float physicsEngineDelta;
    private immutable Vector3 movementSpeed;

    private bool wasOnGround = false;

    this(Game game, Vector3 position) {
        this.game = game;

        this.entity = new Entity(position, Vector2(0.51,1.8),Vector3(0,0,0), true);

        game.world.addEntity(this.entity);

        this.physicsEngineDelta = game.world.getLockedTick();
        this.movementSpeed = Vector3(
            this.physicsEngineDelta / 4.0,
            this.physicsEngineDelta / 4.0,
            this.physicsEngineDelta / 4.0
        );
    }

    void update() {

        this.intakeControls();

        Vector3 position = this.entity.getPosition();

        position.y += this.eyeHeight;

        game.camera3d.setPosition(position);

    }

    void intakeControls() {

        if (!game.world.didTick()) {
            return;
        }
        // Don't allow player to control in mid air
        if (!this.entity.wasOnTheGround()) {
            return;
        }

        // We're talking to the next engine steps here so it gets kinda weird
        this.entity.appliedForce = false;

        Keyboard keyboard = game.keyboard;
        GameCamera camera3d = game.camera3d;

        bool changed = false;

        Vector3 addingVelocity = Vector3(0,0,0);

        if (keyboard.getForward()) {
            changed = true;
            Vector3 direction = Vector3Multiply(camera3d.getForward2d(), this.movementSpeed);
            addingVelocity = Vector3Add(addingVelocity, direction);
        }
        if (keyboard.getBack()) {
            changed = true;
            Vector3 direction = Vector3Multiply(camera3d.getBackward2d(), this.movementSpeed);
            addingVelocity = Vector3Add(addingVelocity, direction);
        }
        if (keyboard.getRight()) {
            changed = true;
            Vector3 direction = Vector3Multiply(camera3d.getRight2d(), this.movementSpeed);
            addingVelocity = Vector3Add(addingVelocity, direction);
        }
        if (keyboard.getLeft()) {
            changed = true;
            Vector3 direction = Vector3Multiply(camera3d.getLeft2d(), this.movementSpeed);
            addingVelocity = Vector3Add(addingVelocity, direction);
        }
        if (keyboard.getJump()) {
            changed = true;
            addingVelocity = Vector3Add(addingVelocity, Vector3(0,0.25,0));
            writeln("jumped");
        } else if (keyboard.getRun()) {
            // Vector3 direction = Vector3Multiply(camera3d.getDown2d(), movementSpeed);
            // velocity = Vector3Add(velocity, direction);
        }

        if (changed) {
            this.entity.addVelocity(addingVelocity);
            this.entity.appliedForce = true;
        }
    }

    Vector3 getPosition() {
        return this.entity.getCollisionBoxPosition();
    }

    Vector3 getModelPosition() {
        Vector3 modelPosition = this.entity.getCollisionBoxPosition();
        modelPosition.y += modelYAdjust;
        return modelPosition;
    }
}