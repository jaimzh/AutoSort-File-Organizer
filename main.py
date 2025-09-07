from autosort.core.autosort import AutoSort

if __name__ == "__main__":
    try:
        auto = AutoSort()
    except FileNotFoundError:
        print("❌ Error: 'config.json' not found. Please create one.")
        exit() # Stop the script if config is missing

    while True:
        choice = input(
            "\n--- AutoSort ---\n"
            "1: Scan Now\n"
            "2: Monitor Folder\n"
            "3: Exit\n"
            "👉 Choose an option: "
        )

        if choice == '1':
            auto.scan_now()
            print("✅ Scan finished.")
        elif choice == '2':
            auto.start_monitor()
            input("👀 Monitoring is active. Press Enter to stop...\n")
            auto.stop_monitor()
        elif choice == '3':
            print("👋 Exiting.")
            break
        else:
            print("⚠️ Invalid option. Please enter 1, 2, or 3.")