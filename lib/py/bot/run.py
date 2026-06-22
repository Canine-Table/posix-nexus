
# Import the required modules

import discord

import os

import logging

from discord.ext import commands 

from dotenv import load_dotenv

import requests

load_dotenv()

WEBHOOK_URL = os.getenv("WEBHOOK_URL")

# Create a Discord client instance and set the command prefix

intents = discord.Intents.all()

client = discord.Client(intents=intents)

bot = commands.Bot(command_prefix='!', intents=intents)

logging.basicConfig(

    level=logging.INFO,

    format='[%(asctime)s] [%(levelname)s]: %(message)s',

    handlers=[

        logging.FileHandler('bot.log'),

        logging.StreamHandler()

    ]

)

# Set the confirmation message when the bot is ready

@bot.event

async def on_ready():

    print(f'Logged in as {bot.user.name}')

@bot.event 

async def on_command_error(ctx, error):

    error_message = f'Error occured while processing command: {error}'

    logging.error(error_message)

    await ctx.send(error_message)

# Set the commands for your bot

@bot.command()

async def message(ctx, *, content: str = None):

    """Sends a message to the webhook when !message is used"""

    # Check if the user provided a message

    if not content:

        await ctx.send("Please provide a message after !message.")

        return

    # Prepare the payload for the webhook

    payload = {

        'username': ctx.author.display_name,

        'content': content,

        'avatar_url': ctx.author.avatar.url if ctx.author.avatar else None,

    }

    # Send the payload to the webhook URL

    try:

        response = requests.post(WEBHOOK_URL, json=payload)

        response.raise_for_status()

        await ctx.send("Message sent successfully!")

        print(f'Message forwarded: {content}')

    except requests.exceptions.RequestException as e:

        await ctx.send("Failed to send the message.")

        print(f'Failed to forward message: {e}')

# Retrieve token from the .env file

bot.run(os.getenv('TOKEN'))

