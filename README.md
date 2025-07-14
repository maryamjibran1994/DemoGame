# 🎮 Gravity Shift - Roblox Game

A thrilling 3D platformer where players navigate through challenging maps by manipulating gravity in all directions!

## 🌟 Features

### Core Gameplay
- **Gravity Manipulation**: Press SPACE to cycle through 6 different gravity directions (Up, Down, Left, Right, Forward, Back)
- **Dynamic Maps**: 5 unique maps with increasing difficulty
- **Platform Variety**: Basic, moving, breakable, and bounce platforms
- **Coin Collection**: Collect coins for rewards and progression
- **Checkpoint System**: Save progress through challenging sections

### Progression System
- **Level System**: Gain experience and level up to unlock new maps
- **Currency**: Earn coins and Robux for purchases
- **Statistics Tracking**: Monitor your performance and achievements
- **Best Times**: Compete for fastest completion times

### Shop System
- **Power-ups**: Speed boost, jump boost, gravity master, coin magnet
- **Cosmetics**: Character skins and VIP access
- **Dual Currency**: Purchase with in-game coins or Robux

### Maps
1. **Tutorial** - Learn the basics of gravity shifting
2. **Sky High** - Navigate through floating platforms
3. **Maze Runner** - Complex maze with gravity puzzles
4. **Speed Demon** - Fast-paced gravity challenges
5. **Master's Challenge** - Ultimate gravity mastery test

## 🎯 How to Play

### Controls
- **WASD** - Move character
- **SPACE** - Change gravity direction
- **R** - Restart current map
- **ESC** - Pause menu

### Objective
Navigate through each map by:
1. Using gravity shifts to reach platforms
2. Collecting coins for rewards
3. Reaching checkpoints to save progress
4. Finding the finish platform to complete the level

### Tips
- Plan your gravity shifts ahead of time
- Use the gravity indicator to know current direction
- Collect coins for better rewards
- Watch out for moving and breakable platforms
- Use checkpoints strategically

## 🏗️ Technical Architecture

### File Structure
```
src/
├── shared/
│   ├── GameConfig.luau      # Game settings and configuration
│   ├── PlayerData.luau      # Player data management
│   ├── MapGenerator.luau    # Procedural map generation
│   └── UISystem.luau        # UI creation and management
├── server/
│   ├── GameManager.luau     # Main server game logic
│   └── init.server.luau     # Server initialization
└── client/
    ├── GameController.luau  # Main client game logic
    └── init.client.luau     # Client initialization
```

### Key Systems
- **Data Persistence**: Player data saved using DataStoreService
- **Remote Events**: Client-server communication
- **Procedural Generation**: Maps generated dynamically
- **UI Framework**: Custom UI system built with Roblox GUI
- **Physics Integration**: Custom gravity manipulation

## 🚀 Getting Started

1. **Open in Roblox Studio**: Load the project in Roblox Studio
2. **Test the Game**: Press Play to test the game
3. **Customize**: Modify GameConfig.luau to adjust game settings
4. **Deploy**: Publish to Roblox when ready

## ⚙️ Configuration

### Game Settings (GameConfig.luau)
- Gravity speed and cooldown
- Player movement settings
- UI colors and themes
- Map configurations
- Shop items and prices

### Map Generation (MapGenerator.luau)
- Platform placement algorithms
- Coin distribution
- Checkpoint positioning
- Obstacle generation

## 🎨 Customization

### Adding New Maps
1. Add map data to `GameConfig.MAPS`
2. Create generation function in `MapGenerator.luau`
3. Update difficulty progression

### Adding Shop Items
1. Add item data to `GameConfig.SHOP_ITEMS`
2. Define effects in `GameConfig.POWERUP_EFFECTS`
3. Update purchase logic in `GameManager.luau`

### UI Customization
- Modify colors in `GameConfig.COLORS`
- Update UI layouts in `UISystem.luau`
- Add new UI components as needed

## 🔧 Troubleshooting

### Common Issues
- **Character not spawning**: Check character loading in client script
- **Gravity not working**: Verify physics settings and input handling
- **UI not showing**: Check ScreenGui creation and parent assignment
- **Data not saving**: Verify DataStoreService permissions

### Debug Tips
- Use `print()` statements for debugging
- Check Output window for errors
- Verify remote event connections
- Test individual systems in isolation

## 📈 Future Enhancements

### Planned Features
- **Multiplayer Support**: Race against other players
- **Custom Maps**: Player-created map system
- **Leaderboards**: Global and friend leaderboards
- **Achievements**: Unlockable achievements system
- **Sound Effects**: Audio feedback and music
- **Particle Effects**: Visual effects for actions
- **Mobile Support**: Touch controls for mobile devices

### Technical Improvements
- **Performance Optimization**: Better frame rate handling
- **Network Optimization**: Reduced bandwidth usage
- **Error Handling**: More robust error recovery
- **Analytics**: Player behavior tracking

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🎉 Credits

Created with ❤️ using Roblox Studio and Luau programming language.

---

**Enjoy playing Gravity Shift!** 🎮✨