# Bug Bound: Design Doc

---

## Table of Contents

- **[Game Overview](#game-overview)**
    - **[Pitch & Hook](#pitch--hook)**
    - **[Identity](#identity)**
    - **[Core Game Loops](#core-game-loops)**
    - **[Unique Selling Propositions (USPs)](#unique-selling-propositions-usps)**
- **[Design Pillars](#design-pillars)**
- **[Core Features](#core-features)**
    - **[Multiplayer](#multiplayer)**
    - **[Wilderness](#wilderness)**
    - **[Capture Minigame](#capture-minigame)**
    - **[Shop](#shop)**
    - **[Terrarium](#terrarium)**
    - **[Weather & Time System](#weather--time-system)**
- **[Supporting Features](#supporting-features)**
    - **[HUD & Field Utilities](#hud--field-utilities)**
    - **[Inventory & Collection Journal (The Field Guide)](#inventory--collection-journal-the-field-guide)**
    - **[Quests & Bulletin Board](#quests--bulletin-board)**
    - **[Consumable Quick-Bar & Bait Setup](#consumable-quick-bar--bait-setup)**
    - **[Proximity Voice & Social Emote Wheel](#proximity-voice--social-emote-wheel)**
    - **[Player Customization & Upgrades](#player-customization--upgrades)**
- **[Content & Aesthetics](#content--aesthetics)**
    - **[Insectopedia (Bug Catalog & Archetypes)](#insectopedia-bug-catalog--archetypes)**
    - **[Audio & Soundscape Design](#audio--soundscape-design)**
    - **[UI Design](#ui-design)**
    - **[Art Design](#art-design)**
    - **[Controls & Input Mapping](#controls--input-mapping)**
- **[Milestones](#milestones)**
    - **[Proof of Concept (PoC)](#proof-of-concept-poc)**
    - **[First Playable (Prototype)](#first-playable-prototype)**
    - **[Vertical Slice](#vertical-slice)**
    - **[Minimum Viable Product (MVP)](#minimum-viable-product-mvp)**
    - **[Alpha Testing](#alpha-testing)**
    - **[Minimum Marketable Product (MMP)](#minimum-marketable-product-mmp)**
    - **[Minimum Marketable Release (MMR)](#minimum-marketable-release-mmr)**

---

# Game Overview

---

## Pitch & Hook

- **Elevator Pitch:** _Bug Bound_ is a cozy, multiplayer 3D creature-collection
  game where friends roam a living wilderness together, tracking and capturing
  unique 2D bugs through tactile circle-drawing minigames, before bringing their
  catches back to display in a shared community terrarium.

- **The Hook:** Every bug hunt is a high-stakes, skill-based dance of stealth
  and dexterity. Sneak up on wildlife for a tactical advantage, or risk getting
  caught off-guard when an alerted bug forces an active encounter on you.

---

## Identity

- **Genre:** Co-op 3D Cozy Exploration & Action-Puzzle Catching
- **Platform:** PC
- **Target Audience:**
    - Fans of relaxing, social multiplayer games (like _Webfishing_ or _Animal
      Crossing_).
    - Players who enjoy skill-based interaction and collection mechanics over
      passive RNG grinds.
    - Friends looking for a low-stress, cooperative space to explore and show
      off achievements.

---

## Core Game Loops

### Macro (Progression & Social)

- Check Forecast (Weather/Time)
- Explore Shared Wilderness
- Deploy Bait & Lures
- Catch Bugs
- Sell Duplicates at Town Shop OR Deposit in Shared Terrarium
- Buy Gear Upgrades & Cosmetics

### Micro (Stealth & Capture)

- Sneak Through Brush
- Proximity Check / Noise Radius Trigger
- Player Initiative: Stealth Advantage OR Bug Initiative: Off-Guard Penalty
- Enter Capture Arena
- Draw Continuous Circle around Bug while Dodging Attacks
- Fill Capture Progress to Win (or Deplete Focus/Timeout to Lose)

---

## Unique Selling Propositions (USPs)

- **Tactile 2D-in-3D Creature Collection:** Unlike passive RNG-roll collection
  games, _Bug Bound_ transforms every catch into a physical skill check where
  players draw continuous circles around dynamic, 2D animated bug sprites while
  actively dodging real-time arena hazards.
- **Cooperative Wilderness Exploration & Stealth:** A living, reactive 3D
  ecosystem where player movement generates noise, forcing friends to balance
  stealth positioning and proximity tracking to ambush rare wildlife together.
- **Shared Social Hubs & Living Displays:** Seamless integration between
  cooperative outdoor hunting, individual town shopping, and a massive shared
  community terrarium where friends showcase rare catches and custom cosmetic
  progression.

---

# Design Pillars

Our design pillars serve as a strict guideline for every mechanic, system, and
asset added to the game. If a proposed feature violates any of these pillars, it
must be reworked or cut.

- **Low-Stress Social Harmony:** The game fosters a warm, inviting community
  atmosphere. Multiplayer interactions emphasize cooperation, shared
  exploration, and showing off achievements rather than direct competition,
  griefing, or harsh player-versus-player conflict.

- **Tactile, Mastery-Driven Interaction:** Core gameplay relies on player skill,
  physical timing, and rhythmic precision rather than passive RNG rolls or
  mindless button-mashing.

- **An Organic, Reactive Ecosystem:** The world feels genuinely alive. Bugs are
  not static spawn points; they possess behavioral states, respond dynamically
  to weather, time, and player noise, and inhabit a simulated natural
  environment.

---

# Core Features

These are the indispensable foundational pillars of the game. Without these
mechanics fully functional, the game cannot exist.

---

## Multiplayer

The backend infrastructure and party systems that allow players to seamlessly
gather, sync environments, and explore together in real-time.

### Mechanics

- **Squad & Party System:** Allows players to form a dedicated party via invite
  codes or friend lists, sharing a private HUD party frame, pooled map markers,
  and synchronized session status.
- **Instance & Weather Sync:** Automatically syncs the host's or session's
  active **Weather & Time System** state across all connected players so
  everyone experiences the same environmental shifts simultaneously.

### Pillar Alignment

- **Low-Stress Social Harmony:** Removes friction from joining friends, ensuring
  cooperation and shared exploration are effortless from the moment a session
  starts.

---

## Wilderness

A persistent 3D wilderness where all players in a session roam, explore, and
hunt together in real-time.

### Mechanics

- **Movement & Noise:** Players control their movement speed. Walking or running
  generates a large noise radius that alerts nearby wildlife. Holding the sneak
  key lowers movement speed and muffles footsteps.
- **Proximity & Behavioral AI:** Bugs exist dynamically in the 3D world as
  visible entities. As players approach, bugs evaluate distance, line-of-sight,
  and sound through active behavioral states:
    - **Calm:** The bug behaves naturally (walking, resting, eating).
    - **Suspicious:** The bug detects a noise or movement nearby. It pauses,
      turns toward the source, and enters a brief warning window.
    - **Alerted:** The bug fully registers the threat and makes an active
      behavioral choice: it will either **engage** the player to force a combat
      encounter, or choose to **flee** into the brush.
- **Engagement Initiative:**
    - **Player-Initiated:** If the player gets close enough without being
      spotted, they can manually choose a bug and trigger capture mode on their
      own terms.
    - **Bug-Initiated:** If a bug becomes alerted and chooses to engage, it
      forces an encounter on the player, dragging them into the capture minigame
      immediately.

### Pillar Alignment

- **Organic, Reactive Ecosystem:** Bugs make distinct choices to fight or flee
  based on alert states.
- **Low-Stress Social Harmony:** Exploring side-by-side with friends.

---

## Capture Minigame

A focused, single-player skill-check interface triggered instantly when capture
mode is engaged.

### Mechanics

- **Capture Arena:** The interface frames a 2D animated bug sprite moving
  dynamically across a dedicated capture canvas.
- **Player Action:** The player uses their catching tool by clicking and
  dragging the mouse to draw a continuous line, forming a closed circle around
  the moving bug.
- **Resource Management:**
    - **Player Focus:** A meter that continuously drains while the mouse button
      is held down and drawing. (Starts partially depleted if the bug initiated
      the encounter and caught the player off-guard).
    - **Bug Capture Progress:** A progress bar representing the bug's remaining
      resilience. Every successfully completed, unbroken circle drains a chunk
      of this meter. (Starts partially filled if the player successfully
      initiated stealth and caught the bug off-guard).
- **Bug Counter-Actions & Hazards:** While the player draws, the bug executes
  active, archetype-specific traits (e.g., a Stag Beetle snaps its mandibles, a
  Scorpion swings its tail, a Flea makes a massive jump across the screen).
  These attacks target the arena space; if an attack intersects the player's
  cursor or drawn line, the line shatters instantly and inflicts a player
  resource penalty.
- **Win Condition:** The bug's capture progress meter fills completely,
  resulting in a successful catch.
- **Lose Conditions:**
    - **Exhaustion:** The player's focus meter empties completely.
    - **Timeout:** The encounter timer expires before the capture progress meter
      is filled.
    - **Result of Loss:** The bug breaks free, escapes the arena, and flees back
      into the wilderness.

### Pillar Alignment

- **Tactile, Mastery-Driven Interaction:** Demands precise mouse control, route
  optimization around bug movement patterns, and active reflex dodging to
  succeed rather than relying on RNG.
- **An Organic, Reactive Ecosystem:** The arena behavior, movement rules, and
  starting advantages directly reflect how the encounter began in the living
  world.

---

## Shop

A physical, shared storefront building in town that acts as the primary economic
hub for the player's progression loop.

### Mechanics

- **Shared Social Space, Private Transactions:** Players can walk into the shop
  building together in real time to see each other hanging out, but interacting
  with the counter opens an individual, private shop interface.
- **Selling Duplicates:** Players sell bugs caught in the shared forest to the
  shopkeeper in exchange for the main currency.
- **Purchasing Gear & Supplies:** Players spend their currency to buy upgrades,
  consumables, and cosmetics.

### Pillar Alignment

- **Low-Stress Social Harmony:** Fosters cozy, social community hangouts inside
  the storefront without item competition, bidding wars, or forced
  player-versus-player trading economics.
- **Tactile, Mastery-Driven Interaction:** Directly supports player progression
  by letting players buy equipment upgrades that enhance their field and capture
  capabilities.

---

## Terrarium

A community vivarium where players deposit and showcase their collected
specimens in a massive shared enclosure.

### Mechanics

- **Living Ecosystem Simulation:** Bugs placed inside automatically crawl
  around, rest, eat, and occasionally trigger harmless passive interactions with
  each other.
- **Social Trophy Case:** Acts as a centralized display hub for the lobby,
  allowing players to inspect rare sizes, variants, and catches owned by others.

### Pillar Alignment

- **Low-Stress Social Harmony:** Provides a cozy, non-competitive space for
  friends to hang out, admire each other's collections, and show off
  achievements.
- **An Organic, Reactive Ecosystem:** Extends the living world concept into a
  simulated habitat where collected wildlife continues to behave naturally.

---

## Weather & Time System

An environmental management system that combines distinct time cycles and
weather conditions to dynamically alter the wilderness.

### Mechanics

- **Mutually Exclusive Time & Independent Weather:** The world runs on a strict
  time cycle (e.g., Day vs. Night—never both at once) overlaid with independent
  weather conditions (such as Clear, Rain, Snow, or Heat wave), allowing
  combinations like a rainy night or a sunny day.
- **Ecosystem Spawning Rules:** Specific, rare bug species only emerge when
  precise environmental combinations are met (e.g., Rain + Night combo).

### Pillar Alignment

- **An Organic, Reactive Ecosystem:** Directly ensures the wilderness feels
  genuinely alive, forcing players to pay attention to the forecast rather than
  finding every bug everywhere at any time.
- **Tactile, Mastery-Driven Interaction:** Rewards player preparation, strategy,
  and timing when choosing _when_ and _where_ to hunt based on environmental
  states.

---

# Supporting Features

These features directly support the Core Features by providing the player with
real-time situational awareness.

---

## HUD & Field Utilities

A cohesive heads-up display and gear overlay that feeds vital environmental and
navigational data directly to the player during active exploration.

### Mechanics

- **The Watch (Time Tracking):**
    - **What it is:** A portable UI or equipped watch item that displays the
      current time cycle (Day vs. Night).
    - **Core Connection:** Directly supports the **Weather & Time System** by
      letting players check when environmental shifts are about to occur so they
      can hunt specific time-dependent bugs.
- **Current Weather Forecast & Notice:**
    - **What it is:** A clean HUD indicator or forecast menu showing active
      weather conditions (Clear, Rain, Snow, Heat wave).
    - **Core Connection:** Directly supports the **Weather & Time System** and
      **Wilderness**, enabling players to plan their excursions based on active
      spawning rules.
- **Minimap / Wilderness Radar:**
    - **What it is:** A localized map of the persistent 3D world displaying
      player positions, town structures (like the Shop and Terrarium), and
      general regional zones.
    - **Core Connection:** Directly supports the **Wilderness** by helping
      players navigate the shared map, coordinate with friends, and locate areas
      of interest.

### Core Alignment

- **Wilderness & Weather & Time System:** Directly bridges environmental
  tracking with active exploration by supplying the real-time situational data
  needed to navigate shifts, track local structures, and coordinate multiplayer
  excursions.

### Pillar Alignment

- **Tactile, Mastery-Driven Interaction:** Empowers players with clear
  information, turning hunting into an intentional strategy rather than blind
  wandering.
- **Low-Stress Social Harmony:** Helps friends coordinate their locations and
  objectives easily within the shared multiplayer space.

---

## Inventory & Collection Journal (The Field Guide)

A portable catalog and storage system that logs every bug the player has
encountered, caught, and traded.

### Mechanics

- **The Field Guide (Encyclopedia):** Automatically unlocks behavioral lore,
  preferred weather conditions, spawn locations, and size records for every
  species once captured.
- **Categorized Storage:** Manages caught bugs before they are sold at the
  **Shop** or deposited into the **Terrarium**.

### Core Alignment

- **Wilderness & Weather & Time System:** Gives players a tangible, cataloged
  record of missing species, behavioral lore, and environmental spawn clues,
  directly driving future exploration and weather-targeted hunting trips.

### Pillar Alignment

- **Tactile, Mastery-Driven Interaction:** Rewards thorough exploration and
  collection tracking.
- **Low-Stress Social Harmony:** Provides a clean way to inspect personal
  collection milestones and compare progress with friends.

---

## Quests & Bulletin Board

A localized town board and NPC request system that gives structured, rotating
goals to players.

### Mechanics

- **Town Bulletin Board:** Offers daily or weekly community requests (e.g.,
  catching specific bug types during a heat wave, or tracking down oversized
  specimens).
- **Milestone Rewards:** Awards bonus currency, rare cosmetic blueprints, or
  unique bait recipes upon completion.

### Core Alignment

- **Wilderness & Weather & Time System:** Gives players focused, intentional
  reasons to hunt specific environmental combinations rather than wandering
  aimlessly.

### Pillar Alignment

- **Tactile, Mastery-Driven Interaction:** Encourages players to master
  difficult weather conditions and advanced capture techniques to fulfill
  tougher bounties.
- **Low-Stress Social Harmony:** Fosters shared community objectives where
  friends can team up to knock out town requests together.

---

## Consumable Quick-Bar & Bait Setup

A fast-access item slot system used while roaming the 3D environment.

### Mechanics

- **Lures & Incense Deployment:** Allows players to place aromatic baits or
  environment-specific incense on the ground or trees to attract rare,
  weather-dependent bugs to a specific area in the **Wilderness**.
- **Quick-Use Tools:** Instantly access utility items purchased from the
  **Shop**.

### Core Alignment

- **Shop & Wilderness:** Directly translates the economic progression of the
  shop into active field power by letting players deploy purchased lures and
  incense to manipulate local wilderness spawn conditions.

### Pillar Alignment

- **Tactile, Mastery-Driven Interaction:** Rewards player preparation and field
  strategy rather than relying purely on random luck when searching for rare
  critters.

---

## Proximity Voice & Social Emote Wheel

A communication suite designed for seamless multiplayer interaction in shared
spaces.

### Mechanics

- **Positional Voice & Chat:** Spatial audio that lets players chat naturally
  while walking through the **Wilderness** or hanging out in the **Terrarium**
  and **Shop**.
- **Expressive Emotes:** A quick-select wheel for waving, pointing out rare
  bugs, and cheering.

### Core Alignment

- **Wilderness, Shop, & Terrarium:** Enhances all shared multiplayer zones by
  providing spatial audio and expressive emotes that foster seamless
  cooperation, communication, and social hangouts.

### Pillar Alignment

- **Low-Stress Social Harmony:** Fosters a welcoming, cooperative atmosphere
  where friends can call out rare bug sightings or celebrate a successful catch
  together.

---

## Player Customization & Upgrades

The physical gear progression and cosmetic wardrobe system fueled by the
**Shop**.

### Mechanics

- **Catching Tool Upgrades:** Purchase and equip advanced nets or tools from the
  **Shop** that directly alter the **Capture Minigame** parameters (e.g., larger
  capture canvases, slower player focus drain, or increased bug resilience
  damage).
- **Cosmetic Wardrobe:** Swappable hats, backpacks, outfits, and color palettes
  purchased with currency or unlocked via milestones.

### Core Alignment

- **Shop, Capture Minigame, & Terrarium:** Links economic progression directly
  to field capabilities and visual identity, giving players tangible goals to
  work toward during excursions.

### Pillar Alignment

- **Tactile, Mastery-Driven Interaction:** Upgrading tools changes how players
  approach difficult catches, rewarding progression with more ergonomic and
  forgiving minigame mechanics.
- **Low-Stress Social Harmony:** Gives players unique visual identities to
  express themselves and show off achievements while hanging out in the shared
  town, shop, and terrarium.

---

# Content & Aesthetics

---

## Insectopedia (Bug Catalog & Archetypes)

The comprehensive breakdown of bug species, sizes, behavioral archetypes, and
environmental spawn conditions that populate the living wilderness.

### Mechanics

- **Bug Archetypes & Minigame Hazards:** Bugs are categorized into distinct
  behavioral archetypes that dictate both their 3D wilderness movement and their
  active hazards inside the **Capture Minigame**:
    - **Crawlers (e.g., Beetles, Caterpillars):** Slow and methodical in the
      world; predictable ground movement patterns in the arena with occasional
      heavy defense pulses (e.g., shell slams that shatter drawn lines).
    - **Jumpers (e.g., Fleas, Grasshoppers):** Twitchy and easily startled in
      the brush; execute sudden, screen-spanning leaps in the arena that
      instantly break player focus if caught in the jump path.
    - **Fliers (e.g., Moths, Dragonflies):** Highly erratic aerial movement;
      float smoothly across the capture canvas while occasionally dropping
      blinding dust or erratic sonic pulses that disrupt cursor tracking.
    - **Ambushers (e.g., Scorpions, Spiders):** Stationary or slow-roaming until
      approached; boast aggressive, fast counter-attacks (e.g., quick stings or
      web traps) that drain player focus on contact.
- **Size & Variant Tiers:** Every species spawns with randomized scale factors
  (Small, Normal, Large, Giant) and rare color variants tied to specific weather
  conditions or milestones.

### Core Alignment

- **Wilderness, Capture Minigame, & Field Guide:** Provides the underlying data
  for what players track in the world, battle in the minigame, and log in their
  collection journal.

### Pillar Alignment

- **Tactile, Mastery-Driven Interaction:** Forces players to learn the unique
  behavioral tells and attack patterns of each archetype rather than relying on
  a one-size-fits-all catching strategy.
- **An Organic, Reactive Ecosystem:** Ensures every critter feels distinct,
  alive, and true to its real-world counterpart.

---

## Audio & Soundscape Design

The auditory architecture designed to cultivate a cozy, immersive atmosphere
while providing crucial spatial feedback for multiplayer exploration and
stealth.

### Mechanics

- **Environmental Soundscapes:** Dynamic ambient audio layers that shift in real
  time based on the active **Weather & Time System** (e.g., gentle crickets and
  echoing owl calls at night, rhythmic patter and heavy droplet plops during
  rain).
- **Surface-Based Footstep & Stealth Audio:** Procedural audio cues tied to
  player movement speed in the **Wilderness**; walking on crunching leaves or
  twigs generates a distinct local noise radius cue, while sneaking muffles
  footfalls into soft rustles.
- **Bug Spatial Audio:** Distinct, directional audio tags (buzzing wings,
  skittering claws, chirps) emitted by 3D bugs in the world, allowing attentive
  players to locate rare species purely by sound before seeing them.
- **UI & Minigame Audio Chimes:** Crisp, tactile feedback sounds for drawing
  strokes, successful circle completions, and warning hums when the player focus
  meter runs low.

### Core Alignment

- **Wilderness & Proximity Voice:** Enhances spatial immersion, helping players
  track wildlife and communicate seamlessly via positional voice chat.

### Pillar Alignment

- **Low-Stress Social Harmony:** Warm, gentle sonic palettes reinforce the
  relaxing, inviting atmosphere of shared community spaces like the shop and
  terrarium.
- **Tactile, Mastery-Driven Interaction:** Sound acts as a mechanical
  tool—players listen closely to audio cues to judge bug distance and detect
  incoming stealth threats.

---

## UI Design

The structural layout, ergonomic hierarchy, and functional specification for
every heads-up display element, radial overlay, and modal menu in the game.

### HUD Elements

- **Dynamic Visibility Rules:** Minimalist, non-intrusive layout that remains
  subtle or fades out during quiet exploration, sliding smoothly into active
  view when tracking environmental changes, status alerts, or party updates.
- **Player Status Frames:** Compact health and focus meters docked discreetly in
  the upper corners to monitor real-time resource availability.
- **Party Member HUD Frames:** Compact session frames tracking teammate
  locations, health states, and online statuses in the upper-left quadrant.
- **The Watch (Time Tracker):** A persistent or quick-reference clock interface
  displaying the active Day vs. Night cycle.
- **Weather Forecast & Notice Banner:** A clean indicator showing active
  environmental conditions (Clear, Rain, Snow, Heat wave) and incoming weather
  shifts.
- **Minimap / Wilderness Radar:** A localized radar map in the corner displaying
  regional terrain, town structures, player positions, and custom map markers.
- **Consumable Quick-Bar:** A persistent 4-slot gear tracker along the bottom
  edge showing active bait, lures, or quick-use tools tied to number keys or
  D-pad inputs.

### Menus

- **The Quick-Access Radial Menu (Tab Overlay):** A centralized 8-way navigation
  interface that pops up when holding Tab or North Button, keeping the screen
  clean during active exploration while providing instant access to primary
  menus:
    - **North (Up):** Inventory / Bag (Manages caught bugs, consumable items,
      and general gear storage).
    - **North-East:** Insectopedia / Field Guide (Catalogs unlocked bug lore,
      sizes, spawn conditions, and collection milestones).
    - **East:** Character Customization (Swaps equipped outfits, hats,
      backpacks, and color palettes).
    - **South-East:** Map & Wilderness Radar (Displays regional layout, player
      positions, and fast-travel or objective markers).
    - **South (Down):** Quests & Bulletin Board (Tracks active town requests,
      bounties, and community milestones).
    - **South-West:** Terrarium (Views or fast-travels to the shared community
      vivarium display hub).
    - **West:** Shop / Town Hub (Accesses economic storefront summaries or
      fast-travels back to town).
    - **North-West:** Settings & System (Manages audio, video, controls, and
      multiplayer session/party options).
- **System Pause & Escape Menu:** Toggled instantly via Esc on keyboard or Start
  on controller over active gameplay. Features interactive buttons for **Return
  to Game**, **Settings**, **Quit to Main Menu**, and **Quit Game**.
- **Shop Interface:** Private individual storefront menu accessed by interacting
  with the town shopkeeper while in the shared multiplayer building.

### Pop-Ups & Modals

- **Capture Arena UI:** Framed overlay canvas activated during a bug encounter,
  displaying the 2D animated bug sprite, live player focus meter, and bug
  capture progress bar.
- **Social Emote Wheel:** Quick-select radial selector for expressions, emotes,
  and positional voice pings.
- **Notification Banners:** Floating modal alerts for milestone unlocks, quest
  completions, and weather shift announcements.

### Core Alignment

- **All Core & Supporting Features:** Serves as the primary interaction layer
  and navigational framework for every system in the game.

### Pillar Alignment

- **Low-Stress Social Harmony:** Clean, friendly visual hierarchy and intuitive
  radial menu navigation ensure players never feel overwhelmed by cluttered
  windows or hostile UI design.

---

## Art Design

The visual direction, asset style guide, and aesthetic rules that unite chunky
3D low-poly environments with crisp 2D sprite art.

### Mechanics

- **Art Direction & Visual Style:** A stylized, low-stress visual blend
  featuring chunky, colorful 3D low-poly environments, cozy lighting, and
  modular characters paired with crisp, hand-animated 2D sprite art for all bugs
  and interactive elements.
- **Environment & Prop Aesthetics:** Natural organic shapes, warm lighting
  passes, and readable silhouettes designed to make exploration inviting and
  clear.
- **Menu & Interface Aesthetics:** Cozy, paper-and-wood textured windows
  designed to feel tactile, warm, and integrated into the game's physical world
  rather than clinical or sterile.

### Core Alignment

- **Wilderness, Shop, Terrarium, & UI:** Sets the cohesive aesthetic tone for
  all physical spaces, characters, interfaces, and collectible critters.

### Pillar Alignment

- **Low-Stress Social Harmony:** Warm, charming visual presentation fosters a
  welcoming, relaxing atmosphere where friends can comfortably hang out and
  explore together.

---

## Controls & Input Mapping

The standardized control scheme designed to make movement, stealth, and
high-stakes mouse-dragging fluid and accessible, broken down cleanly by player
intent and input device.

### Standard Movement & Exploration

- **Keyboard & Mouse Controls:**
    - **Movement:** WASD (Continuous movement in 3D space).
    - **Camera Control:** Free-mode / orbital camera. Holding Right Mouse Button
      (RMB) allows mouse movement to rotate the camera around the player;
      standard camera follows behind movement when RMB is released.
    - **Sprint (Hold):** Left Shift (Increases movement speed and expands noise
      radius).
    - **Sneak (Hold):** Left Alt (Lowers movement speed and suppresses footstep
      noise radius).
    - **Jump:** Spacebar (Clears low environmental clutter and gaps).
    - **Interact / Catch:** E (Engages targeted bugs, town NPCs, or objects).
- **Controller Controls:**
    - **Movement:** Left Stick (Continuous movement in 3D space).
    - **Camera Control:** Right Stick (Rotates the camera freely around the
      player).
    - **Sprint (Hold):** Left Trigger / LT (Increases movement speed and expands
      noise radius).
    - **Sneak (Hold):** Left Bumper / LB (Lowers movement speed and suppresses
      footstep noise radius).
    - **Jump:** South Button / A (Xbox) or Cross (PlayStation) (Clears low
      environmental clutter and gaps).
    - **Interact / Catch:** West Button / X (Xbox) or Square (PlayStation)
      (Engages targeted bugs, town NPCs, or objects).

### Capture Minigame

- **Keyboard & Mouse Controls:**
    - **Draw / Hold:** Left Mouse Click and Drag (Draws continuous capture line;
      releasing shatters progress or drains focus).
    - **Quick-Bar Items:** Number Row 1–4 (Deploys active bait, lures, or
      tools).
- **Controller Controls:**
    - **Draw / Hold:** Right Stick or Touch Input (Draws continuous capture
      line; releasing shatters progress or drains focus).
    - **Quick-Bar Items:** D-Pad Up / Down / Left / Right (Deploys active bait,
      lures, or tools).

### UI Interaction & Navigation

- **Keyboard & Mouse Controls:**
    - **Radial Menu (Hold):** Tab (Brings up the 8-way navigation overlay; mouse
      cursor selects the slice).
    - **Social Emote Wheel (Hold):** Q (Opens quick-select emote and voice ping
      menu).
    - **Escape Menu:** Esc (Opens/closes the system pause menu).
    - **Close Active Window:** Esc (Immediately closes any active open UI window
      or radial overlay).
- **Controller Controls:**
    - **Radial Menu (Hold):** North Button / Y (Xbox) or Triangle (PlayStation)
      (Brings up the 8-way navigation overlay; Right Stick selects the slice).
    - **Social Emote Wheel (Hold):** Right Bumper / RB (Opens quick-select emote
      and voice ping menu).
    - **Escape Menu:** Start Button / Options (Opens/closes the system pause
      menu).
    - **Close Active Window:** East Button / B (Xbox) or Circle (PlayStation)
      (Immediately closes any active open UI window or radial overlay).

### Core Alignment

- **Wilderness & Capture Minigame:** Directly translates player physical input
  into precise spatial navigation, smooth camera tracking, and high-precision
  circle-drawing mechanics across both input methods.

### Pillar Alignment

- **Tactile, Mastery-Driven Interaction:** Responsive, tight input mapping and
  intuitive menu navigation ensure that managing movement states, inventory,
  system pauses, and capture minigames always feels fluid and tied directly to
  player dexterity.

---

# Milestones

The structured production timeline for _Bug Bound_, broken down into distinct
development phases, core definitions, and specific feature implementations.

---

## Proof of Concept (PoC)

- **Definition:** A raw technical and mechanical spike. The sole objective here
  is to answer: _"Can we catch bugs, and is this core interaction fundamentally
  fun?"_ At this stage, the economic or social loops do not exist yet; you are
  purely validating that drawing circles around a 2D sprite inside a 3D Godot
  environment feels satisfying.
- **Features Implemented:**
    - Basic Godot 3D project setup with Git LFS asset pipeline validation.
    - Local or basic networked multiplayer movement replication (server/client
      sync).
    - Prototype 2D capture canvas running inside a 3D world with basic
      mouse-drag circle detection.
- **Exit Criteria:** A developer can host a basic session, join with a second
  client, approach a placeholder bug, and successfully trigger and complete the
  circle-drawing minigame without crashing.

---

## First Playable (Prototype)

- **Definition:** The milestone where the core gameplay loop comes together with
  friends. This phase ensures you can connect to a session with others, sneak
  through a prototype environment, and execute the full micro-loop from start to
  finish.
- **Features Implemented:**
    - Basic 3D wilderness terrain prototype with placeholder trees and brush.
    - Movement speed states (walking vs. sneaking) tied to basic noise radius
      logic.
    - Basic bug AI states (Calm, Suspicious, Alerted) with simple flee or engage
      logic.
    - Functional capture minigame featuring player focus drain, bug health
      resilience, and one active bug hazard.
    - Basic multiplayer connection and session synchronization.
- **Exit Criteria:** Internal playtesters can connect together, smoothly sneak
  through the woods, trigger an encounter either proactively or reactively, and
  complete a full capture loop from start to finish.

---

## Vertical Slice

- **Definition:** A completely polished, representative "micro-experience" of
  the game. While it doesn't contain every single supporting feature or item
  planned for the final release, all **Core Features** must be fully finished,
  balanced, and rendered at production quality to establish the definitive
  visual and audio benchmark for the project.
- **Features Implemented:**
    - One fully polished regional biome featuring low-poly 3D environments and
      stylized lighting.
    - A representative selection of bugs spanning multiple behavioral archetypes
      with full 2D sprite animations and unique arena hazards.
    - Fully functional core loops: Wilderness hunting, Capture Minigame, Town
      Shop, and a basic iteration of the shared Terrarium.
    - Integrated audio soundscapes, surface-based footsteps, and UI radial
      menus.
- **Exit Criteria:** External or cross-functional playtesters experience a
  polished 15-to-20-minute slice of the game that looks, sounds, and feels like
  a finished product aligned with our USPs.

---

## Minimum Viable Product (MVP)

- **Definition:** The complete foundational game. Every core and supporting
  feature is wired up and playable from end to end. It may lack deep content
  variety or heavy polish, but it contains all system architecture necessary to
  expand into a full game.
- **Features Implemented:**
    - Full multiplayer squad/party system and session weather/time sync.
    - Complete town hub featuring the Shop, Bulletin Board quests, and the fully
      interactive Terrarium.
    - Full supporting features: HUD & field utilities, the Field Guide catalog,
      consumable quick-bars, and the social emote/proximity voice suite.
    - Basic player customization (initial tools and cosmetic wardrobe).
- **Exit Criteria:** A closed group of players can play a complete session from
  end to end—exploring, weather-hunting, catching bugs, buying upgrades, and
  displaying catches—without blocking bugs.

---

## Alpha Testing

- **Definition:** A feature-freeze and community validation phase. Alpha is used
  to see how external players interact with the game, stress-test networking
  under real-world conditions, and ensure the foundational loop is engaging
  enough that players want to return. Changes and fixes derived from this data
  are then implemented.
- **Features Implemented:**
    - All planned bug species, variants, and sizes implemented.
    - Full quest lines, bulletin board rotations, and progression balancing
      (shop prices, tool upgrade stats).
    - Comprehensive bug-fixing pass and performance optimization for Godot
      multiplayer networking.
- **Exit Criteria:** All features are feature-complete. Playtesters can
  experience the full breadth of content without critical blockers or severe
  desync issues, and telemetry/feedback confirms strong core retention
  potential.

---

## Minimum Marketable Product (MMP)

- **Definition:** The commercial release build. At this milestone, the game
  fully matches and delivers upon all stated **USPs**, offering a polished,
  stable, and competitive package ready to stand shoulder-to-shoulder with other
  titles in the cozy multiplayer space on PC.
- **Features Implemented:**
    - Fully optimized release build with complete store page integration,
      achievements, and cloud saves.
    - Clean onboarding flow and tutorial systems for new players.
    - Full balance pass ensuring all core mechanics, capture minigames, and
      economies are robust and market-ready.
- **Exit Criteria:** Successful submission and approval on target storefronts,
  fully capable of competing commercially on launch day.

---

## Minimum Marketable Release (MMR)

- **Definition:** The post-launch maturation phase. Prior to major seasonal
  drops, public beta test branches are run here to ensure updates work
  seamlessly. The overarching goal is to delight the community, maintain server
  stability, and continuously expand ecosystem depth based on live player
  feedback.
- **Features Implemented:**
    - Public beta test environments for upcoming patches and seasonal updates.
    - First post-launch content updates (e.g., new seasonal biomes, rare bug
      archetypes, or extended terrarium decorations).
    - Community-driven balance patches and quality-of-life updates based on
      launch telemetry and player reports.
- **Exit Criteria:** Sustained player retention, positive community sentiment,
  and a healthy, predictable pipeline for ongoing live-ops content drops.
