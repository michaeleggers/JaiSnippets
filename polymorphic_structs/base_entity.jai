/* Use polymorphic structs to kinda do what we would do in C++ with classes and
   dynamic dispatch.
*/

#import "Basic";
#import "Math";


Camera :: struct {
    up := Vector3.{0.0, 0.0, 1.0};
    center := Vector3.{0.0, 0.0, 0.0};
    right := Vector3.{1.0, 0.0, 0.0};
};

HandleCameraInputProc :: (keycode : u32) {
    print("Camera input received keycode: %\n", keycode);
}

Player :: struct {
    name : string;
};

HandlePlayerInputProc :: (keycode : u32) {
    print("Player input received keycode: %\n", keycode);
}

BaseEntity :: struct {
    type : Type;
    position : Vector3;

    HandleInput : (keycode : u32);
}

Entity :: struct ($X: Type) {
    #as using base: BaseEntity;

    base.type = X;
    base.position = .{0.0, 0.0, 1.0};

    instance : X;
}

SetEntityInputHandler :: (entity : *BaseEntity, InputHandlerProc : (keycode : u32)) {
    entity.HandleInput = InputHandlerProc;
}

MoveEntity :: (entity : *BaseEntity, velocity : Vector3) {    
    entity.position += velocity;
}

main :: () {
    myPlayer : Entity(Player);
    followCamera : Entity(Camera);

    SetEntityInputHandler(*myPlayer, HandlePlayerInputProc);
    SetEntityInputHandler(*followCamera, HandleCameraInputProc); 

    allMyEntities : [..] *BaseEntity;
    array_add(*allMyEntities, *myPlayer);
    array_add(*allMyEntities, *followCamera);

    print("myPlayer: %\n", myPlayer);
    print("followCamera: %\n", followCamera);

    for allMyEntities {
        MoveEntity(it, Vector3.{10, 20, 12.3});
    }

    print("myPlayer: %\n", myPlayer);
    print("followCamera: %\n", followCamera);

    myPlayer.HandleInput(10);
    followCamera.HandleInput(20);

    print("myPlayer: %\n", myPlayer);


}